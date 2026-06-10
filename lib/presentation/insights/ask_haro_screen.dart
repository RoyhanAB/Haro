import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_formatter.dart';
import '../../domain/services/insight_service.dart';
import '../../domain/services/summary_service.dart';
import '../../state/app_providers.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/haro_hero.dart';
import '../common/quick_chip.dart';

class AskHaroScreen extends ConsumerWidget {
  const AskHaroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final profile = state.userProfile!;
    final month = DateTime.now();
    final expense = getMonthlyExpense(state.transactions, month);
    final daily = calculateDailySafeSpending(
      profile,
      state.transactions,
      month,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Tanya Haro')),
      body: AppScreen(
        children: [
          const HaroHero(
            title: 'Tanya Haro',
            message: 'Saran Haro berdasarkan catatanmu.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Bulan ini boros di mana?',
              'Aman nggak sampai gajian?',
              'Berapa jatah jajan per hari?',
              'Apa yang bisa dikurangi?',
            ].map((item) => QuickChip(label: item, onTap: () {})).toList(),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(generateHaroInsight(profile, state.transactions, month)),
                const SizedBox(height: 12),
                Text('Breakdown: pengeluaran bulan ini ${formatIDR(expense)}.'),
                Text(
                  'Rekomendasi: jaga jajan harian di sekitar ${formatIDR(daily)}.',
                ),
                const Text('Aksi berikutnya: catat transaksi kecil hari ini.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
