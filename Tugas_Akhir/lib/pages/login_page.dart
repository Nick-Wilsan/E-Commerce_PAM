import 'package:flutter/material.dart';
import '../state/app_state_scope.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

static const routeName = '/login';

@override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

@override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

final appState = AppStateScope.of(context);

try {
      await appState.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

if (!mounted) {
        return;
      }

Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (_) {
      if (!mounted) {
        return;
      }

ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appState.errorMessage ?? 'Login gagal.')),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.school_rounded, size: 48),
                    const SizedBox(height: 24),
                    Text(
                      'Masuk ke BelajarKu',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lanjutkan materi dan pantau progres belajar.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

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

PrimaryButton(
                      label: 'Login',
                      icon: Icons.login_rounded,
                      isLoading: appState.isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),

TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: const Text('Belum punya akun? Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
