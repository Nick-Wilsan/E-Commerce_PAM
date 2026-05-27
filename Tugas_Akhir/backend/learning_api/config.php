<?php

// FILE KONFIGURASI BACKEND.
//
// File ini dipakai oleh semua endpoint PHP:
// - register.php
// - login.php
// - lessons.php
// - progress.php
// - complete_lesson.php
//
// Fungsi utamanya:
// 1. Mengatur header HTTP agar backend mengembalikan JSON.
// 2. Mengatur koneksi database MySQL.
// 3. Menyediakan helper untuk membaca JSON request.
// 4. Menyediakan helper response sukses/error.
//
// Jika menjelaskan backend, file ini dibaca pertama.
// Setelah ini lanjut ke register.php atau login.php.

declare(strict_types=1);

// Header CORS ini mengizinkan aplikasi Flutter/HP mengakses backend.
// Tanpa header ini, request dari platform tertentu bisa ditolak browser.
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

// Backend selalu mengembalikan data JSON.
header('Content-Type: application/json; charset=utf-8');

// Request OPTIONS biasanya dikirim sebelum request asli pada kasus CORS.
// Jika method-nya OPTIONS, backend langsung mengembalikan status 204.
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Konfigurasi database.
// Database ini dibuat dari file `backend/database.sql`.
const DB_HOST = 'localhost';
const DB_NAME = 'learning_app';
const DB_USER = 'root';
const DB_PASS = '';

// Function db() membuat koneksi PDO ke MySQL.
//
// PDO dipakai karena:
// - lebih aman,
// - mendukung prepared statement,
// - umum dipakai untuk PHP native.
function db(): PDO
{
    static $pdo = null;

    // Koneksi dibuat satu kali saja.
    // Jika function db() dipanggil lagi, koneksi lama dipakai ulang.
    if ($pdo === null) {
        $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4';
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            // Jika ada error database, PDO akan melempar exception.
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,

            // Hasil query otomatis berupa associative array.
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }

    return $pdo;
}

// Membaca body JSON dari request Flutter/Postman.
//
// Contoh body register:
// {
//   "name": "Mahasiswa",
//   "email": "mahasiswa@example.com",
//   "password": "123456"
// }
function request_body(): array
{
    $body = file_get_contents('php://input');
    $data = json_decode($body ?: '{}', true);

    return is_array($data) ? $data : [];
}

// Helper response sukses.
//
// Semua response sukses punya format:
// {
//   "success": true,
//   ...
// }
function json_success(array $data = [], int $status = 200): void
{
    http_response_code($status);
    echo json_encode(['success' => true] + $data);
    exit;
}

// Helper response gagal.
//
// Semua response error punya format:
// {
//   "success": false,
//   "message": "..."
// }
function json_error(string $message, int $status = 400): void
{
    http_response_code($status);
    echo json_encode(['success' => false, 'message' => $message]);
    exit;
}

// Validasi field wajib.
//
// Dipakai di register/login/complete lesson agar backend tidak memproses data
// kosong. Jika ada field kosong, function langsung mengembalikan JSON error.
function require_fields(array $data, array $fields): void
{
    foreach ($fields as $field) {
        if (!isset($data[$field]) || trim((string) $data[$field]) === '') {
            json_error("Field {$field} wajib diisi.");
        }
    }
}
