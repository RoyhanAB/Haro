import 'package:flutter/material.dart';

import '../common/app_button.dart';
import '../common/haro_hero.dart';
import '../common/status_chip.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const HaroHero(
              title: 'Halo, aku Haro!',
              message:
                  'Aku bantu catat uangmu, baca struk, dan ngingetin kalau kamu mulai kalap.',
            ),
            const SizedBox(height: 20),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: 'Chat transaksi'),
                StatusChip(label: 'Scan struk'),
                StatusChip(label: 'Pantau budget'),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Mulai',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Sudah punya akun? Masuk',
              isSecondary: true,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: Text('Data uangmu tetap dalam kendalimu.')),
          ],
        ),
      ),
    );
  }
}
