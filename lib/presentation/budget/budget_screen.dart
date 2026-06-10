import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_formatter.dart';
import '../../domain/services/summary_service.dart';
import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/haro_mood_card.dart';
import '../common/progress_bar.dart';
import 'budget_section.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final profile = state.userProfile!;
    final expense = getMonthlyExpense(state.transactions, DateTime.now());
    final limit = profile.monthlyBudget;
    final daily = calculateDailySafeSpending(
      profile,
      state.transactions,
      DateTime.now(),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: AppScreen(
        children: [
          HaroMoodCard(
            label: limit > 0 && expense > limit * 0.8
                ? 'Haro mulai waspada'
                : 'Haro santai tapi tetap jaga',
            message: 'Jatah aman hari ini: ${formatIDR(daily)}.',
          ),
          const SizedBox(height: 16),
          BudgetSection(profile: profile, transactions: state.transactions),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengeluaran rutin',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text('Kos • Internet • Langganan'),
                const SizedBox(height: 12),
                const Text(
                  'Haro saranin budget makanan Rp900.000 bulan depan.',
                ),
                const SizedBox(height: 12),
                ProgressBar(value: limit == 0 ? 0 : expense / limit),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(label: 'Atur Budget', icon: Icons.tune, onPressed: () {}),
        ],
      ),
    );
  }
}
