<?php

// ENDPOINT DAFTAR MATERI.
//
// URL:
// GET http://172.16.30.9/learning_api/lessons.php?user_id=1
//
// Fungsi:
// - Mengambil semua materi dari tabel `lessons`.
// - Mengecek apakah setiap materi sudah selesai oleh user.
// - Mengembalikan list materi ke Flutter.
//
// Kenapa perlu user_id?
// Karena status selesai/belum selesai berbeda untuk tiap user.
//
// Setelah file ini, lihat:
// - `lib/services/api_service.dart`, method `fetchLessons`.
// - `lib/pages/dashboard_page.dart`.

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    // user_id dikirim lewat query string.
    // Contoh: lessons.php?user_id=1
    $userId = (int) ($_GET['user_id'] ?? 0);

    if ($userId <= 0) {
        json_error('user_id wajib valid.');
    }

    // Query ini mengambil data dari tabel lessons.
    //
    // LEFT JOIN dipakai agar semua materi tetap muncul walaupun belum ada
    // progress di tabel user_progress.
    //
    // CASE WHEN dipakai untuk membuat field `is_completed`:
    // - 0 jika belum selesai,
    // - 1 jika sudah selesai.
    $stmt = db()->prepare(
        'SELECT
            lessons.id,
            lessons.title,
            lessons.description,
            lessons.content,
            lessons.duration_minutes,
            CASE WHEN user_progress.id IS NULL THEN 0 ELSE 1 END AS is_completed
        FROM lessons
        LEFT JOIN user_progress
            ON user_progress.lesson_id = lessons.id
            AND user_progress.user_id = ?
        ORDER BY lessons.id ASC'
    );
    $stmt->execute([$userId]);

    json_success(['lessons' => $stmt->fetchAll()]);
} catch (Throwable $error) {
    json_error('Server error: ' . $error->getMessage(), 500);
}
