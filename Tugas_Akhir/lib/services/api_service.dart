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

Future<List<Lesson>> fetchLessons(int userId) async {
    final response = await _client.get(_uri('lessons.php?user_id=$userId'));
    final data = _decode(response);

final lessons = data['lessons'] as List<dynamic>;

return lessons
        .map((lesson) => Lesson.fromJson(lesson as Map<String, dynamic>))
        .toList();
  }

Future<ProgressSummary> fetchProgress(int userId) async {
    final response = await _client.get(_uri('progress.php?user_id=$userId'));
    final data = _decode(response);
    return ProgressSummary.fromJson(data['progress'] as Map<String, dynamic>);
  }

Future<void> completeLesson({
    required int userId,
    required int lessonId,
  }) async {
    final response = await _client.post(
      _uri('complete_lesson.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'lesson_id': lessonId}),
    );

_decode(response);
  }

Map<String, dynamic> _decode(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;

if (response.statusCode >= 400 || body['success'] != true) {
      throw ApiException(body['message']?.toString() ?? 'Terjadi kesalahan.');
    }

return body;
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

final String message;

@override
  String toString() => message;
}
