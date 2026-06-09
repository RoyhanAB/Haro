import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/id_generator.dart';
import '../../core/utils/money_formatter.dart';
import '../../domain/models/user_profile.dart';
import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_text_field.dart';
import '../common/haro_avatar.dart';

class SetupProfileScreen extends ConsumerStatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  ConsumerState<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends ConsumerState<SetupProfileScreen> {
  final _name = TextEditingController();
  final _budget = TextEditingController();
  final _income = TextEditingController();
  HaroTone _tone = HaroTone.lucu;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _budget.dispose();
    _income.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(child: HaroAvatar(size: 88, accessory: '💛')),
            const SizedBox(height: 24),
            Text(
              'Kenalan dulu, yuk',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Haro akan menyesuaikan catatan dan insight sesuai profilmu.',
            ),
            const SizedBox(height: 24),
            AppTextField(controller: _name, hint: 'Nama panggilan'),
            const SizedBox(height: 12),
            AppTextField(
              controller: _budget,
              hint: 'Budget bulanan',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _income,
              hint: 'Pemasukan bulanan (opsional)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text(
              'Gaya Haro',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            SegmentedButton<HaroTone>(
              segments: const [
                ButtonSegment(value: HaroTone.lucu, label: Text('Lucu')),
                ButtonSegment(
                  value: HaroTone.santai,
                  label: Text('Santai'),
                ),
                ButtonSegment(value: HaroTone.tegas, label: Text('Tegas')),
              ],
              selected: {_tone},
              onSelectionChanged: (value) =>
                  setState(() => _tone = value.first),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 24),
            AppButton(label: 'Simpan & Mulai', onPressed: _save),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Nama panggilan wajib diisi.');
      return;
    }
    final now = DateTime.now();
    final profile = UserProfile(
      id: generateId(),
      name: _name.text.trim(),
      currency: 'IDR',
      monthlyBudget: parseIDRText(_budget.text) ?? 0,
      monthlyIncome: parseIDRText(_income.text),
      HaroTone: _tone,
      createdAt: now,
      updatedAt: now,
    );
    ref.read(appStateProvider.notifier).setProfile(profile);
  }
}
