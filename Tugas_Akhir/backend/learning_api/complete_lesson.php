<?php

// ENDPOINT MENANDAI MATERI SELESAI.
//
// URL:
// POST http://172.16.30.9/learning_api/complete_lesson.php
//
// Body JSON:
// {
//   "user_id": 1,
//   "lesson_id": 1
// }
//
// Fungsi:
// - Menyimpan progress user ke tabel `user_progress`.
// - Jika data sudah ada, tidak dibuat duplikat.
//
// Setelah file ini, lihat:
// - `lib/pages/lesson_page.dart`.
// - `lib/state/app_state.dart`, method `completeLesson`.

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    $data = request_body();
    require_fields($data, ['user_id', 'lesson_id']);

    $userId = (int) $data['user_id'];
    $lessonId = (int) $data['lesson_id'];

    if ($userId <= 0 || $lessonId <= 0) {
        json_error('user_id dan lesson_id wajib valid.');
    }

    // INSERT IGNORE dipakai karena tabel user_progress punya UNIQUE KEY
    // `(user_id, lesson_id)`.
    //
    // Artinya user yang sama tidak bisa menyelesaikan materi yang sama dua kali.
    // Jika request dikirim ulang, database mengabaikan duplikatnya.
    $stmt = db()->prepare(
        'INSERT IGNORE INTO user_progress (user_id, lesson_id) VALUES (?, ?)'
    );
    $stmt->execute([$userId, $lessonId]);

    json_success(['message' => 'Progress tersimpan.']);
} catch (Throwable $error) {
    json_error('Server error: ' . $error->getMessage(), 500);
}
