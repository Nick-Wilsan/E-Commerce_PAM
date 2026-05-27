// HALAMAN DASHBOARD.
//
// Halaman ini muncul setelah login/register berhasil.
//
// Fungsi dashboard:
// - Menampilkan nama user.
// - Menampilkan progress belajar dalam bentuk progress bar.
// - Menampilkan daftar materi dari database.
// - Membuka halaman detail materi saat item materi ditekan.
// - Menyediakan tombol logout.
//
// Alur data:
// 1. AppState menyimpan `user`, `lessons`, dan `progress`.
// 2. Dashboard membaca data itu lewat `AppStateScope.of(context)`.
// 3. Jika AppState berubah, Dashboard ikut rebuild.
//
// Setelah membaca file ini, lanjut ke:
// - `lib/pages/lesson_page.dart` untuk detail materi.
// - `lib/state/app_state.dart`, method `loadDashboard`.

import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../state/app_state_scope.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Nama route dashboard.
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    // Mengambil state global.
    final appState = AppStateScope.of(context);
    final user = appState.user;

    // Jika user null, berarti dashboard dibuka tanpa login.
    // Ini kondisi pengaman.
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Sesi tidak ditemukan.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Tombol logout.
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              appState.logout();

              // Menghapus semua route lama dan kembali ke login.
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

      // RefreshIndicator membuat user bisa menarik layar ke bawah untuk
      // mengambil ulang data dashboard dari backend.
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

            // Panel progress dibuat sebagai widget private agar kode lebih rapi.
            const _ProgressPanel(),
            const SizedBox(height: 24),

            Text('Materi', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            // Jika masih loading, tampilkan indikator.
            if (appState.isLoading)
              const Center(child: CircularProgressIndicator())
            // Jika tidak ada materi, tampilkan empty state.
            else if (appState.lessons.isEmpty)
              const _EmptyLesson()
            // Jika ada materi, tampilkan sebagai list kartu.
            else
              ...appState.lessons.map((lesson) => _LessonTile(lesson: lesson)),
          ],
        ),
      ),
    );
  }
}

// Widget private untuk menampilkan progress belajar.
//
// Private berarti hanya dipakai di file ini, ditandai dengan underscore `_`.
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

          // Progress bar menerima nilai 0.0 sampai 1.0.
          LinearProgressIndicator(value: progress.ratio),
          const SizedBox(height: 10),

          // Teks ringkasan progress.
          Text(
            '${progress.completedLessons} dari ${progress.totalLessons} materi selesai',
          ),
        ],
      ),
    );
  }
}

// Widget untuk satu item materi di dashboard.
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

        // Saat materi ditekan, aplikasi pindah ke halaman detail lesson.
        //
        // `arguments: lesson` berarti object lesson dikirim ke LessonPage.
        onTap: () => Navigator.pushNamed(context, '/lesson', arguments: lesson),
      ),
    );
  }
}

// Tampilan jika database belum punya data materi.
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
