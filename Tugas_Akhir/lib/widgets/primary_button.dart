// WIDGET TOMBOL UTAMA YANG DIPAKAI BERULANG.
//
// File ini dibuat agar tombol login/register/tandai selesai punya tampilan
// konsisten dan tidak menulis kode tombol berulang di banyak halaman.
//
// Dipakai di:
// - LoginPage
// - RegisterPage
// - LessonPage

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  // Teks tombol, misalnya "Login" atau "Register".
  final String label;

  // Function yang dijalankan saat tombol ditekan.
  // Jika null, tombol otomatis disabled.
  final VoidCallback? onPressed;

  // Jika true, icon tombol diganti menjadi CircularProgressIndicator.
  final bool isLoading;

  // Icon opsional di sisi kiri teks tombol.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Tombol dibuat selebar parent agar terlihat sebagai tombol aksi utama.
      width: double.infinity,
      height: 52,
      child: FilledButton.icon(
        // Saat loading, tombol dibuat tidak bisa ditekan supaya request tidak
        // terkirim berkali-kali.
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon ?? Icons.arrow_forward_rounded),
        label: Text(label),
      ),
    );
  }
}
