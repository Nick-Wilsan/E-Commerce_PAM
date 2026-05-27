import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state_scope.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

static const routeName = '/dashboard';

@override
  Widget build(BuildContext context) {

final appState = AppStateScope.of(context);
    final user = appState.user;

if (user == null) {
      return const Scaffold(body: Center(child: Text('Sesi tidak ditemukan.')));
    }

return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [

IconButton(
            tooltip: 'Logout',
            onPressed: () {
              appState.logout();

Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),

body: RefreshIndicator(
        onRefresh: appState.loadDashboard,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Halo, ${user.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih materi, selesaikan konten, lalu progres akan tersimpan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

const _ProgressPanel(),
            const SizedBox(height: 24),

Text('Materi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

if (appState.isLoading)
              const Center(child: CircularProgressIndicator())

else if (appState.lessons.isEmpty)
              const _EmptyLesson()

else
              ...appState.lessons.map((lesson) => _LessonTile(lesson: lesson)),
          ],
        ),
      ),
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel();

@override
  Widget build(BuildContext context) {
    final progress = AppStateScope.of(context).progress;

return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_rounded),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${progress.percent}% selesai',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

LinearProgressIndicator(value: progress.ratio),
          const SizedBox(height: 10),

Text(
            '${progress.completedLessons} dari ${progress.totalLessons} materi selesai',
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson});

final Lesson lesson;

@override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Icon(
            lesson.isCompleted ? Icons.check_rounded : Icons.menu_book_rounded,
          ),
        ),
        title: Text(lesson.title),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('${lesson.description}\n${lesson.durationMinutes} menit'),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right_rounded),

onTap: () => Navigator.pushNamed(context, '/lesson', arguments: lesson),
      ),
    );
  }
}

class _EmptyLesson extends StatelessWidget {
  const _EmptyLesson();

@override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(child: Text('Belum ada materi.')),
    );
  }
}
