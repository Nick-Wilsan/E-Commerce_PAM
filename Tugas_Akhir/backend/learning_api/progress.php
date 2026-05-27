<?php

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    $userId = (int) ($_GET['user_id'] ?? 0);

if ($userId <= 0) {
        json_error('user_id wajib valid.');
    }

$total = (int) db()->query('SELECT COUNT(*) FROM lessons')->fetchColumn();

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
