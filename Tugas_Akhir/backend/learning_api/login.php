<?php

declare(strict_types=1);

require __DIR__ . '/config.php';

try {
    $data = request_body();
    require_fields($data, ['email', 'password']);

$email = strtolower(trim((string) $data['email']));
    $password = (string) $data['password'];

$stmt = db()->prepare('SELECT * FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $user = $stmt->fetch();

if (!$user || !password_verify($password, $user['password_hash'])) {
        json_error('Email atau password salah.', 401);
    }

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
