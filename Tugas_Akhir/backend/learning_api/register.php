<?php

// ENDPOINT REGISTER.
//
// URL:
// POST http://172.16.30.9/learning_api/register.php
//
// Body JSON:
// {
//   "name": "Mahasiswa",
//   "email": "mahasiswa@example.com",
//   "password": "123456"
// }
//
// Fungsi:
// - Memvalidasi input.
// - Mengecek apakah email sudah terdaftar.
// - Menyimpan user baru ke tabel `users`.
// - Mengembalikan data user ke Flutter.
//
// Setelah file ini, lihat:
// - `backend/database.sql`, tabel `users`.
// - `lib/services/api_service.dart`, method `register`.

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    // Membaca body JSON dari Flutter/Postman.
    $data = request_body();

    // Nama, email, dan password wajib ada.
    require_fields($data, ['name', 'email', 'password']);

    // Membersihkan input.
    $name = trim((string) $data['name']);
    $email = strtolower(trim((string) $data['email']));
    $password = (string) $data['password'];

    // Validasi format email.
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        json_error('Format email tidak valid.');
    }

    // Validasi panjang password.
    if (strlen($password) < 6) {
        json_error('Password minimal 6 karakter.');
    }

    // Cek apakah email sudah digunakan.
    $stmt = db()->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);

    if ($stmt->fetch()) {
        json_error('Email sudah terdaftar.', 409);
    }

    // Simpan user baru.
    //
    // Password tidak disimpan sebagai teks asli.
    // `password_hash` membuat password lebih aman jika database bocor.
    $stmt = db()->prepare(
        'INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)'
    );
    $stmt->execute([$name, $email, password_hash($password, PASSWORD_DEFAULT)]);

    // Response sukses.
    json_success([
        'message' => 'Register berhasil.',
        'user' => [
            'id' => (int) db()->lastInsertId(),
            'name' => $name,
            'email' => $email,
        ],
    ], 201);
} catch (Throwable $error) {
    // Jika ada error server/database, response tetap berbentuk JSON.
    json_error('Server error: ' . $error->getMessage(), 500);
}
