// HALAMAN REGISTER.
//
// File ini menampilkan form pendaftaran akun baru.
//
// Alur register:
// 1. User mengisi nama, email, dan password.
// 2. Tombol Register ditekan.
// 3. `_submit()` memvalidasi form.
// 4. `_submit()` memanggil `appState.register(...)`.
// 5. AppState memanggil ApiService.
// 6. ApiService mengirim JSON ke `backend/learning_api/register.php`.
// 7. Backend menyimpan user ke tabel `users`.
// 8. Jika berhasil, user langsung masuk ke dashboard.
//
// Setelah membaca file ini, lanjut ke:
// - `lib/state/app_state.dart`, method `register`
// - `lib/services/api_service.dart`, method `register`
// - `backend/learning_api/register.php`

import 'package:flutter/material.dart';

import '../state/app_state_scope.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  // Nama route halaman register.
  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Key untuk mengontrol validasi form.
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil isi input user.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Semua controller dibersihkan saat halaman ditutup.
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method utama saat tombol Register ditekan.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final appState = AppStateScope.of(context);

    try {
      await appState.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      // Setelah register berhasil, user langsung diarahkan ke dashboard.
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (_) {
      if (!mounted) {
        return;
      }

      // Menampilkan pesan error dari backend, misalnya email sudah terdaftar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appState.errorMessage ?? 'Register gagal.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buat akun belajar',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // Input nama user.
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return 'Nama minimal 3 karakter.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input email.
                // Email akan disimpan sebagai identifier unik di database.
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Email tidak valid.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input password.
                // Password tidak langsung disimpan oleh backend. Backend akan
                // menyimpannya dalam bentuk hash.
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password minimal 6 karakter.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Tombol register memakai komponen reusable PrimaryButton.
                PrimaryButton(
                  label: 'Register',
                  icon: Icons.person_add_alt_rounded,
                  isLoading: appState.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
