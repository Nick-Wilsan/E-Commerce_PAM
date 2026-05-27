// FILE INI MENGATUR ALAMAT BACKEND/API.
//
// Alur baca:
// 1. Flutter butuh tahu backend PHP ada di alamat mana.
// 2. `ApiService` akan membaca `ApiConfig.baseUrl`.
// 3. Setelah itu request dikirim ke file PHP seperti `login.php`.
//
// Catatan penting:
// - Kalau tes di HP fisik, gunakan IP Wi-Fi laptop.
// - Kalau IP laptop berubah, ubah angka IP di file ini.
// - Kalau tes di emulator Android, biasanya pakai `10.0.2.2`.
// - Kalau tes Flutter Web di laptop, bisa pakai `localhost`.

import 'package:flutter/foundation.dart';

class ApiConfig {
  // Constructor private agar class ini tidak perlu dibuat object-nya.
  // Kita cukup memanggil `ApiConfig.baseUrl`.
  ApiConfig._();

  // Getter ini menentukan base URL backend sesuai platform.
  static String get baseUrl {
    // Jika aplikasi dijalankan sebagai Flutter Web di browser laptop,
    // `localhost` berarti komputer/laptop sendiri.
    if (kIsWeb) {
      return 'http://localhost/learning_api';
    }

    // Ini dipakai untuk HP fisik.
    // `172.16.30.9` adalah IP Wi-Fi laptop saat backend XAMPP dites.
    // Backend harus bisa dibuka dari browser HP:
    // http://172.16.30.9/learning_api/progress.php?user_id=1
    return 'http://172.16.30.9/learning_api';
  }
}
