<?php

// ENDPOINT PROGRESS.
//
// URL:
// GET http://172.16.30.9/learning_api/progress.php?user_id=1
//
// Fungsi:
// - Menghitung total semua materi.
// - Menghitung jumlah materi yang selesai oleh user.
// - Mengembalikan data progress ke Flutter.
//
// Flutter memakai hasil ini untuk menampilkan LinearProgressIndicator.
//
// Setelah file ini, lihat:
// - `lib/models/progress_summary.dart`.
// - `lib/pages/dashboard_page.dart`, widget `_ProgressPanel`.

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    $userId = (int) ($_GET['user_id'] ?? 0);

    if ($userId <= 0) {
        json_error('user_id wajib valid.');
    }

    // Menghitung total materi dari tabel lessons.
    $total = (int) db()->query('SELECT COUNT(*) FROM lessons')->fetchColumn();

    // Menghitung jumlah progress untuk user tertentu.
    $stmt = db()->prepare(
        'SELECT COUNT(*) FROM user_progress WHERE user_id = ?'
    );
    $stmt->execute([$userId]);
    $completed = (int) $stmt->fetchColumn();

    json_success([
        'progress' => [
            'total_lessons' => $total,
            'completed_lessons' => $completed,
        ],
    ]);
} catch (Throwable $error) {
    json_error('Server error: ' . $error->getMessage(), 500);
}
