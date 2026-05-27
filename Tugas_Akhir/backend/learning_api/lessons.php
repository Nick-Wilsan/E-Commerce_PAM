<?php

declare(strict_types=1);

require __DIR__ . '/config.php';

try {

$userId = (int) ($_GET['user_id'] ?? 0);

if ($userId <= 0) {
        json_error('user_id wajib valid.');
    }

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
