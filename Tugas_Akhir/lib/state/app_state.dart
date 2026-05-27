import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../models/lesson.dart';
import '../models/progress_summary.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  AppState({ApiService? apiService}) : _apiService = apiService ?? ApiService();

final ApiService _apiService;

AppUser? user;

List<Lesson> lessons = const [];

ProgressSummary progress = const ProgressSummary(
    totalLessons: 0,
    completedLessons: 0,
  );

bool isLoading = false;

String? errorMessage;

bool get isLoggedIn => user != null;

Future<void> login(String email, String password) async {
    await _run(() async {
      user = await _apiService.login(email: email, password: password);
      await loadDashboard();
    });
  }

Future<void> register(String name, String email, String password) async {
    await _run(() async {
      user = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );
      await loadDashboard();
    });
  }

Future<void> loadDashboard() async {
    final activeUser = user;

if (activeUser == null) {
      return;
    }

lessons = await _apiService.fetchLessons(activeUser.id);
    progress = await _apiService.fetchProgress(activeUser.id);

notifyListeners();
  }

Future<void> completeLesson(int lessonId) async {
    final activeUser = user;
    if (activeUser == null) {
      return;
    }

await _run(() async {
      await _apiService.completeLesson(
        userId: activeUser.id,
        lessonId: lessonId,
      );

lessons = lessons
          .map(
            (lesson) => lesson.id == lessonId
                ? lesson.copyWith(isCompleted: true)
                : lesson,
          )
          .toList();

progress = ProgressSummary(
        totalLessons: lessons.length,
        completedLessons: lessons.where((lesson) => lesson.isCompleted).length,
      );
    });
  }

void logout() {
    user = null;
    lessons = const [];
    progress = const ProgressSummary(totalLessons: 0, completedLessons: 0);
    errorMessage = null;
    notifyListeners();
  }

Future<void> _run(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

try {
      await action();
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
