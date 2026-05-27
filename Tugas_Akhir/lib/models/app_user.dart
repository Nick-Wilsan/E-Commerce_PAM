// MODEL USER.
//
// File ini menjelaskan bentuk data user yang dikirim backend ke Flutter.
// Backend mengembalikan JSON seperti:
//
// {
//   "id": 1,
//   "name": "Mahasiswa",
//   "email": "mahasiswa@example.com"
// }
//
// Data JSON tersebut diubah menjadi object AppUser agar lebih mudah dipakai
// di Flutter, misalnya `user.name` untuk menampilkan nama di dashboard.

class AppUser {
  const AppUser({required this.id, required this.name, required this.email});

  // ID user dari database MySQL.
  // ID ini penting untuk mengambil progress milik user yang sedang login.
  final int id;

  // Nama user, ditampilkan di dashboard.
  final String name;

  // Email user, dipakai untuk login dan identitas akun.
  final String email;

  // Factory constructor ini mengubah Map JSON menjadi object AppUser.
  //
  // Dipanggil dari `ApiService` setelah backend mengembalikan response login
  // atau register.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      // `toString()` lalu `int.parse()` dipakai supaya aman jika backend
      // mengirim angka sebagai integer atau string.
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      email: json['email'].toString(),
    );
  }
}
