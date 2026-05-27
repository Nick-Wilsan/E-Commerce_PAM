<?php

// ENDPOINT LOGIN.
//
// URL:
// POST http://172.16.30.9/learning_api/login.php
//
// Body JSON:
// {
//   "email": "mahasiswa@example.com",
//   "password": "123456"
// }
//
// Fungsi:
// - Mencari user berdasarkan email.
// - Mengecek password dengan password_verify.
// - Mengembalikan data user jika login berhasil.
//
// Setelah file ini, lihat:
// - `lib/state/app_state.dart`, method `login`.
// - `lib/pages/dashboard_page.dart`, karena user diarahkan ke dashboard.

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    $data = request_body();
    require_fields($data, ['email', 'password']);

    $email = strtolower(trim((string) $data['email']));
    $password = (string) $data['password'];

    // Cari user berdasarkan email.
    $stmt = db()->prepare('SELECT * FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    // Jika user tidak ditemukan atau password salah, login ditolak.
    if (!$user || !password_verify($password, $user['password_hash'])) {
        json_error('Email atau password salah.', 401);
    }

    // Response hanya mengirim data yang aman.
    // password_hash tidak dikirim ke Flutter.
    json_success([
        'message' => 'Login berhasil.',
        'user' => [
            'id' => (int) $user['id'],
            'name' => $user['name'],
            'email' => $user['email'],
        ],
    ]);
} catch (Throwable $error) {
    json_error('Server error: ' . $error->getMessage(), 500);
}
