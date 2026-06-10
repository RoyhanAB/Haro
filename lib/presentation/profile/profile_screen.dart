import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_formatter.dart';
import '../../domain/models/user_profile.dart';
import '../../state/app_providers.dart';
import '../achievements/achievements_screen.dart';
import '../budget/budget_screen.dart';
import '../common/app_button.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/app_text_field.dart';
import '../common/haro_avatar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final profile = state.userProfile!;
    return Scaffold(
      body: AppScreen(
        children: [
          Row(
            children: [
              const HaroAvatar(size: 72, mood: HaroMoodVisual.proud),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    Text(profile.email ?? 'Data lokal HARO'),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Edit profil',
                onPressed: () => _editProfile(context, ref, profile),
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                const _SettingRow('HARO Pro', 'Buka insight lebih pintar'),
                _SettingRow('Budget bulanan', formatIDR(profile.monthlyBudget)),
                _SettingRow(
                  'Pemasukan rutin',
                  formatIDR(profile.monthlyIncome ?? 0),
                ),
                _SettingRow(
                  'Tanggal gajian',
                  profile.payday?.toString() ?? '-',
                ),
                _SettingRow('Gaya bicara Haro', profile.haroTone.name),
                const _SettingRow('Kategori transaksi', 'Default MVP'),
                const _SettingRow('Notifikasi anti kalap', 'Belum aktif'),
                const _SettingRow('Export data', 'Segera hadir'),
                const _SettingRow('Backup & sinkronisasi', 'TODO cloud sync'),
                const _SettingRow('Privasi & keamanan', 'Data tersimpan lokal'),
                const _SettingRow('Pusat bantuan', 'Segera hadir'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Budget',
                  icon: Icons.account_balance_wallet,
                  isSecondary: true,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BudgetScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Pencapaian',
                  icon: Icons.emoji_events,
                  isSecondary: true,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AchievementsScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Keluar',
            icon: Icons.logout,
            isSecondary: true,
            onPressed: () => ref.read(appStateProvider.notifier).logout(),
          ),
          const SizedBox(height: 8),
          AppButton(
            label: 'Hapus semua data lokal',
            icon: Icons.delete_outline,
            isSecondary: true,
            onPressed: () => _clearData(context, ref),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Aku bantu catat, kamu tetap pegang kendali.'),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(
    BuildContext context,
    WidgetRef ref,
    UserProfile profile,
  ) async {
    final name = TextEditingController(text: profile.name);
    final budget = TextEditingController(
      text: profile.monthlyBudget.toString(),
    );
    final income = TextEditingController(
      text: (profile.monthlyIncome ?? 0).toString(),
    );
    var tone = profile.haroTone;
    final updated = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Edit profil',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              AppTextField(controller: name, hint: 'Nama panggilan'),
              const SizedBox(height: 12),
              AppTextField(
                controller: budget,
                hint: 'Budget bulanan',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: income,
                hint: 'Pemasukan bulanan',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              SegmentedButton<HaroTone>(
                segments: const [
                  ButtonSegment(value: HaroTone.lucu, label: Text('Lucu')),
                  ButtonSegment(value: HaroTone.santai, label: Text('Santai')),
                  ButtonSegment(value: HaroTone.tegas, label: Text('Tegas')),
                ],
                selected: {tone},
                onSelectionChanged: (value) =>
                    setState(() => tone = value.first),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: 'Simpan profil',
                onPressed: () => Navigator.pop(
                  context,
                  profile.copyWith(
                    name: name.text.trim().isEmpty
                        ? profile.name
                        : name.text.trim(),
                    monthlyBudget: parseIDRText(budget.text) ?? 0,
                    monthlyIncome: parseIDRText(income.text),
                    haroTone: tone,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    name.dispose();
    budget.dispose();
    income.dispose();
    if (updated != null) {
      ref.read(appStateProvider.notifier).updateProfile(updated);
    }
  }

  Future<void> _clearData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus semua data lokal?'),
        content: const Text(
          'Profil, akun, dan transaksi akan dihapus dari perangkat ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(appStateProvider.notifier).clearAllData();
    }
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}
