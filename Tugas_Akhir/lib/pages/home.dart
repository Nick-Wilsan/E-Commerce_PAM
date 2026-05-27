import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const Icon(Icons.school_rounded, size: 64),
              const SizedBox(height: 24),

              Text(
                'BelajarKu',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 12),

              Text(
                'Aplikasi pembelajaran sederhana dengan backend, navigasi, state, konten, dan progres belajar.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Mulai Belajar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
