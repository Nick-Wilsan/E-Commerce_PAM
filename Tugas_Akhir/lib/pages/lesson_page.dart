import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state_scope.dart';
import '../widgets/primary_button.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

static const routeName = '/lesson';

@override
  Widget build(BuildContext context) {

final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;

final appState = AppStateScope.of(context);

return Scaffold(
      appBar: AppBar(title: const Text('Konten Materi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [

Icon(
                lesson.isCompleted
                    ? Icons.verified_rounded
                    : Icons.menu_book_rounded,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lesson.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

Text('${lesson.durationMinutes} menit'),
          const SizedBox(height: 20),

Text(
            lesson.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 28),

PrimaryButton(
            label: lesson.isCompleted
                ? 'Materi Sudah Selesai'
                : 'Tandai Selesai',
            icon: lesson.isCompleted
                ? Icons.check_circle_rounded
                : Icons.task_alt_rounded,
            isLoading: appState.isLoading,
            onPressed: lesson.isCompleted
                ? null
                : () async {
                    try {

await appState.completeLesson(lesson.id);

if (!context.mounted) {
                        return;
                      }

Navigator.pop(context);
                    } catch (_) {
                      if (!context.mounted) {
                        return;
                      }

ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            appState.errorMessage ?? 'Progress gagal disimpan.',
                          ),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
