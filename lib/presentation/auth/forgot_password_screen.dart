import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
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
            Text('Reset password', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            AppTextField(controller: _email, hint: 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            AppButton(
              label: 'Kirim instruksi reset',
              onPressed: () async {
                await ref.read(appStateProvider.notifier).forgotPassword(_email.text.trim());
                setState(() => _sent = true);
              },
            ),
            if (_sent) ...[
              const SizedBox(height: 16),
              const Text('Instruksi reset sudah dikirim. Cek emailmu ya.'),
            ],
          ],
        ),
      ),
    );
  }
}
