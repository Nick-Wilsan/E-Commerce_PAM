<?php

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

$stmt = db()->prepare(
        'INSERT IGNORE INTO user_progress (user_id, lesson_id) VALUES (?, ?)'
    );
    $stmt->execute([$userId, $lessonId]);

json_success(['message' => 'Progress tersimpan.']);
} catch (Throwable $error) {
    json_error('Server error: ' . $error->getMessage(), 500);
}
