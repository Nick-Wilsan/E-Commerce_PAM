import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/app_user.dart';
import '../models/lesson.dart';
import '../models/progress_summary.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}/$path');

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = _decode(response);

    return AppUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  // Method register dipanggil saat user membuat akun baru.
  //
  // Endpoint backend:
  // POST /register.php
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = _decode(response);
    return AppUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  // Mengambil daftar materi dari backend.
  //
  // `userId` dikirim agar backend bisa menandai materi mana yang sudah selesai
  // untuk user tersebut.
  //
  // Endpoint:
  // GET /lessons.php?user_id=1
  Future<List<Lesson>> fetchLessons(int userId) async {
    final response = await _client.get(_uri('lessons.php?user_id=$userId'));
    final data = _decode(response);

    // Backend mengembalikan list di key `lessons`.
    final lessons = data['lessons'] as List<dynamic>;

    // Setiap item JSON diubah menjadi object Lesson.
    return lessons
        .map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>))
        .toList();
  }

  // Mengambil ringkasan progress user.
  //
  // Endpoint:
  // GET /progress.php?user_id=1
  Future<ProgressSummary> fetchProgress(int userId) async {
    final response = await _client.get(_uri('progress.php?user_id=$userId'));
    final data = _decode(response);
    return ProgressSummary.fromJson(data['progress'] as Map<String, dynamic>);
  }

  // Menyimpan materi yang sudah selesai.
  //
  // Endpoint:
  // POST /complete_lesson.php
  //
  // Backend akan menyimpan data ke tabel `user_progress`.
  Future<void> completeLesson({
    required int userId,
    required int lessonId,
  }) async {
    final response = await _client.post(
      _uri('complete_lesson.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'lesson_id': lessonId}),
    );

    // Tidak perlu return data khusus.
    // Cukup decode untuk memastikan backend mengembalikan success true.
    _decode(response);
  }

  // Method private untuk membaca response backend.
  //
  // Semua endpoint backend dibuat dengan format:
  // {
  //   "success": true/false,
  //   ...
  // }
  //
  // Jika `success` false atau HTTP status >= 400, aplikasi menganggap request
  // gagal dan menampilkan pesan error.
  Map<String, dynamic> _decode(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400 || body['success'] != true) {
      throw ApiException(body['message']?.toString() ?? 'Terjadi kesalahan.');
    }

    return body;
  }
}

// Exception khusus untuk error API.
//
// Dengan class ini, error dari backend bisa dibedakan dari error lain.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
