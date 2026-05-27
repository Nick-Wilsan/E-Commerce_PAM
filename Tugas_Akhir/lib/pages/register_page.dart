import 'package:flutter/material.dart';

import '../state/app_state_scope.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

static const routeName = '/register';

@override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

final _formKey = GlobalKey<FormState>();

final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

@override
  void dispose() {

_nameController.dispose();
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
      await appState.register(
        _nameController.text.trim(),
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
