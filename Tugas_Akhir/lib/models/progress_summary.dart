// MODEL RINGKASAN PROGRESS.
//
// File ini menyimpan jumlah total materi dan jumlah materi yang selesai.
// Dari dua angka itu, aplikasi bisa menghitung persentase progress.
//
// Dipakai di:
// - `AppState` untuk menyimpan progress user.
// - `DashboardPage` untuk menampilkan progress bar.

class ProgressSummary {
  const ProgressSummary({
    required this.totalLessons,
    required this.completedLessons,
  });

  // Jumlah seluruh materi di database.
  final int totalLessons;

  // Jumlah materi yang sudah diselesaikan user.
  final int completedLessons;

  // Ratio adalah angka 0.0 sampai 1.0.
  //
  // LinearProgressIndicator di Flutter membutuhkan value seperti ini:
  // - 0.0 berarti 0%
  // - 0.5 berarti 50%
  // - 1.0 berarti 100%
  double get ratio {
    // Jika belum ada materi, hindari pembagian dengan nol.
    if (totalLessons == 0) {
      return 0;
    }

    return completedLessons / totalLessons;
  }

  // Percent dipakai untuk menampilkan teks, misalnya "50% selesai".
  int get percent => (ratio * 100).round();

  // Mengubah JSON backend menjadi object ProgressSummary.
  factory ProgressSummary.fromJson(Map<String, dynamic> json) {
    return ProgressSummary(
      totalLessons: int.parse(json['total_lessons'].toString()),
      completedLessons: int.parse(json['completed_lessons'].toString()),
    );
  }
}
