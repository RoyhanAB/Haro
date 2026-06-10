import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_text_field.dart';
import '../common/haro_avatar.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(text: 'demo@haro.app');
  final _password = TextEditingController(text: 'haro123');
  bool _remember = true;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(
              child: HaroAvatar(size: 96, mood: HaroMoodVisual.thinking),
            ),
            const SizedBox(height: 16),
            Text(
              'Masuk ke HARO',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const Text('Lanjutkan catatan uangmu bareng Haro.'),
            const SizedBox(height: 20),
            AppTextField(
              controller: _email,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _remember,
                  onChanged: (value) =>
                      setState(() => _remember = value ?? true),
                ),
                const Text('Ingat aku'),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  ),
                  child: const Text('Lupa password?'),
                ),
              ],
            ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            const SizedBox(height: 8),
            AppButton(label: 'Masuk', onPressed: _login),
            const SizedBox(height: 8),
            AppButton(
              label: 'Masuk dengan Google',
              icon: Icons.g_mobiledata,
              isSecondary: true,
              onPressed: () {},
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              ),
              child: const Text('Belum punya akun? Daftar'),
            ),
            const Center(child: Text('Aman dan terenkripsi.')),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final ok = await ref
        .read(appStateProvider.notifier)
        .login(_email.text.trim(), _password.text);
    if (!mounted) return;
    if (ok) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      setState(() => _error = 'Email atau password belum cocok.');
    }
  }
}
