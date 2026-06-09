import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money_formatter.dart';
import '../../domain/services/insight_service.dart';
import '../../domain/services/summary_service.dart';
import '../../state/app_providers.dart';
import '../budget/budget_section.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/insight_card.dart';
import '../common/progress_bar.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final profile = state.userProfile!;
    final month = DateTime.now();
    final income = getMonthlyIncome(state.transactions, month);
    final expense = getMonthlyExpense(state.transactions, month);
    final remaining = getMonthlyRemaining(profile, state.transactions, month);
    final breakdown = getCategoryBreakdown(
      state.transactions,
      month,
    ).entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxCategory = breakdown.isEmpty ? 1 : breakdown.first.value;

    return Scaffold(
      body: AppScreen(
        children: [
          Text(
            'Statistik',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text('Bulan ini'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Total Pengeluaran',
                  value: formatIDR(expense),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniStat(
                  label: 'Total Pemasukan',
                  value: formatIDR(income),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MiniStat(label: 'Sisa Uang', value: formatIDR(remaining)),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengeluaran per kategori',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                if (breakdown.isEmpty)
                  const Text('Belum ada kategori bulan ini.')
                else
                  ...breakdown.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key} • ${formatIDR(entry.value)}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          ProgressBar(value: entry.value / maxCategory),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tren mingguan',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 12),
                Text('Minggu 1: Rp0'),
                Text('Minggu 2: Rp0'),
                Text('Minggu 3: Rp0'),
                Text('Minggu 4: Rp0'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          InsightCard(
            text: generateHaroInsight(profile, state.transactions, month),
          ),
          const SizedBox(height: 16),
          BudgetSection(profile: profile, transactions: state.transactions),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
