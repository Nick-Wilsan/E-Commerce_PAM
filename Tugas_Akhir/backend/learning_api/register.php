<?php

declare(strict_types=1);

require __DIR__ . '/config.php';

try {

$data = request_body();

require_fields($data, ['name', 'email', 'password']);

$name = trim((string) $data['name']);
    $email = strtolower(trim((string) $data['email']));
    $password = (string) $data['password'];

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        json_error('Format email tidak valid.');
    }

if (strlen($password) < 6) {
        json_error('Password minimal 6 karakter.');
    }

$stmt = db()->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);

if ($stmt->fetch()) {
        json_error('Email sudah terdaftar.', 409);
    }

$stmt = db()->prepare(
        'INSERT INTO users (name, email, password_hash) VALUES (?, ?, ?)'
    );
    $stmt->execute([$name, $email, password_hash($password, PASSWORD_DEFAULT)]);

json_success([
        'message' => 'Register berhasil.',
        'user' => [
            'id' => (int) db()->lastInsertId(),
            'name' => $name,
            'email' => $email,
        ],
    ], 201);
} catch (Throwable $error) {

json_error('Server error: ' . $error->getMessage(), 500);
}
