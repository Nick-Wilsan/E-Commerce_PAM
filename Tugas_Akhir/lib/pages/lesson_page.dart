// HALAMAN DETAIL KONTEN MATERI.
//
// File ini menampilkan satu materi yang dipilih dari DashboardPage.
//
// Alur:
// 1. User menekan salah satu materi di dashboard.
// 2. Dashboard menjalankan `Navigator.pushNamed(..., arguments: lesson)`.
// 3. LessonPage menerima object Lesson dari `ModalRoute`.
// 4. Judul, durasi, dan isi materi ditampilkan.
// 5. Jika user menekan "Tandai Selesai", progress disimpan ke backend.
//
// Setelah membaca file ini, lanjut ke:
// - `lib/state/app_state.dart`, method `completeLesson`.
// - `backend/learning_api/complete_lesson.php`.

import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state_scope.dart';
import '../widgets/primary_button.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  // Nama route halaman detail materi.
  static const routeName = '/lesson';

  @override
  Widget build(BuildContext context) {
    // Mengambil data Lesson yang dikirim dari DashboardPage.
    //
    // Karena DashboardPage mengirim object Lesson melalui `arguments`,
    // di sini kita mengambilnya kembali dengan ModalRoute.
    final lesson = ModalRoute.of(context)!.settings.arguments as Lesson;

    // Mengambil AppState untuk memanggil completeLesson.
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Konten Materi')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              // Icon berubah sesuai status selesai/belum.
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

          // Menampilkan estimasi durasi materi.
          Text('${lesson.durationMinutes} menit'),
          const SizedBox(height: 20),

          // Isi materi dari database.
          Text(
            lesson.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 28),

          // Tombol selesai.
          // Jika materi sudah selesai, tombol dibuat disabled.
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
                      // Menyimpan progress ke backend.
                      await appState.completeLesson(lesson.id);

                      if (!context.mounted) {
                        return;
                      }

                      // Setelah berhasil, kembali ke dashboard.
                      Navigator.pop(context);
                    } catch (_) {
                      if (!context.mounted) {
                        return;
                      }

                      // Jika gagal, tampilkan pesan error.
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
