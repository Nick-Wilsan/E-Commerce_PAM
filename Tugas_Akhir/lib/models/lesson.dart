// MODEL MATERI/LESSON.
//
// File ini mendefinisikan bentuk data materi pembelajaran.
// Data materi berasal dari endpoint backend:
// `lessons.php?user_id=...`
//
// Model ini dipakai di:
// - DashboardPage untuk menampilkan daftar materi.
// - LessonPage untuk menampilkan isi materi.
// - AppState untuk menyimpan daftar materi yang sedang aktif.

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.durationMinutes,
    required this.isCompleted,
  });

  // ID materi dari tabel `lessons`.
  final int id;

  // Judul materi, ditampilkan di dashboard dan halaman detail.
  final String title;

  // Deskripsi singkat materi, ditampilkan di kartu dashboard.
  final String description;

  // Isi lengkap materi, ditampilkan di halaman detail konten.
  final String content;

  // Estimasi durasi belajar dalam menit.
  final int durationMinutes;

  // Status apakah materi sudah diselesaikan user atau belum.
  // Nilai ini berasal dari gabungan tabel `lessons` dan `user_progress`.
  final bool isCompleted;

  // Mengubah JSON dari backend menjadi object Lesson.
  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: int.parse(json['id'].toString()),
      title: json['title'].toString(),
      description: json['description'].toString(),
      content: json['content'].toString(),
      durationMinutes: int.parse(json['duration_minutes'].toString()),

      // Backend bisa mengirim `is_completed` sebagai angka 1/0 atau boolean.
      // Karena itu pengecekan dibuat fleksibel.
      isCompleted:
          json['is_completed'].toString() == '1' ||
          json['is_completed'] == true,
    );
  }

  // copyWith dipakai saat user menekan "Tandai Selesai".
  //
  // Daripada mengubah object lama secara langsung, kita membuat salinan object
  // Lesson dengan nilai `isCompleted` yang baru. Cara ini lebih aman karena data
  // model tetap immutable.
  Lesson copyWith({bool? isCompleted}) {
    return Lesson(
      id: id,
      title: title,
      description: description,
      content: content,
      durationMinutes: durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
