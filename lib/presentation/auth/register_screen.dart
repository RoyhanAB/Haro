import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/validators.dart';
import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_text_field.dart';
import '../common/haro_avatar.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _terms = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
            const Center(child: HaroAvatar(size: 96, mood: HaroMoodVisual.happy)),
            const SizedBox(height: 16),
            Text('Buat akun HARO', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const Text('Biar Haro bisa bantu jaga uangmu dari sekarang.'),
            const SizedBox(height: 20),
            AppTextField(controller: _name, hint: 'Nama'),
            const SizedBox(height: 12),
            AppTextField(controller: _email, hint: 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            AppTextField(controller: _password, hint: 'Password'),
            const SizedBox(height: 12),
            AppTextField(controller: _confirm, hint: 'Konfirmasi password'),
            Row(
              children: [
                Checkbox(value: _terms, onChanged: (value) => setState(() => _terms = value ?? false)),
                const Expanded(child: Text('Aku setuju data tersimpan lokal untuk MVP HARO.')),
              ],
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            AppButton(label: 'Daftar', onPressed: _register),
            const SizedBox(height: 8),
            AppButton(label: 'Daftar dengan Google', icon: Icons.g_mobiledata, isSecondary: true, onPressed: () {}),
            TextButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              child: const Text('Sudah punya akun? Masuk'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_name.text.trim().isEmpty || !isValidEmail(_email.text.trim()) || !isStrongEnoughPassword(_password.text)) {
      setState(() => _error = 'Nama, email, dan password minimal 6 karakter wajib valid.');
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Konfirmasi password belum sama.');
      return;
    }
    if (!_terms) {
      setState(() => _error = 'Setujui ketentuan dulu, ya.');
      return;
    }
    await ref.read(appStateProvider.notifier).register(_name.text.trim(), _email.text.trim(), _password.text);
    if (mounted) Navigator.popUntil(context, (route) => route.isFirst);
  }
}
