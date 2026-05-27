












CREATE DATABASE IF NOT EXISTS learning_app
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE learning_app;









CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);










CREATE TABLE IF NOT EXISTS lessons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  content TEXT NOT NULL,
  duration_minutes INT NOT NULL DEFAULT 5,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);








CREATE TABLE IF NOT EXISTS user_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  lesson_id INT NOT NULL,
  completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_user_lesson (user_id, lesson_id),
  CONSTRAINT fk_progress_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_progress_lesson
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
    ON DELETE CASCADE
);




INSERT INTO lessons (title, description, content, duration_minutes) VALUES
('Pengenalan Flutter', 'Memahami widget, layout, dan hot reload.',
'Flutter adalah framework untuk membuat aplikasi multiplatform dari satu basis kode. Konsep utamanya adalah widget. Setiap tampilan disusun dari widget kecil seperti Text, Row, Column, Container, dan Scaffold. Dengan memahami komposisi widget, kamu bisa membuat UI yang rapi dan mudah dikembangkan.',
8),
('Dasar State Management', 'Menyimpan perubahan data agar UI ikut berubah.',
'State adalah data yang memengaruhi tampilan aplikasi. Pada proyek ini state dikelola dengan ChangeNotifier dan InheritedNotifier agar login, daftar materi, dan progress dapat dipakai lintas halaman. Saat state berubah, notifyListeners akan meminta UI melakukan rebuild.',
10),
('Koneksi Backend PHP', 'Mengirim dan menerima data dari API PHP.',
'Aplikasi Flutter memanggil endpoint PHP menggunakan HTTP. Backend membaca JSON, memproses database MySQL dengan PDO, lalu mengembalikan response JSON. Pola ini memisahkan tugas UI dan penyimpanan data sehingga aplikasi lebih mudah diuji menggunakan Postman.',
12),
('Progress Pembelajaran', 'Mencatat materi yang sudah diselesaikan user.',
'Setiap kali user menekan tombol Tandai Selesai, aplikasi mengirim user_id dan lesson_id ke backend. Backend menyimpan data ke tabel user_progress. Dashboard menghitung persentase berdasarkan jumlah materi selesai dibanding total materi.',
7);
