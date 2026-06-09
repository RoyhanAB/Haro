import 'package:flutter/material.dart';

import '../../core/utils/money_formatter.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/services/summary_service.dart';
import '../common/app_button.dart';
import '../common/app_card.dart';
import '../common/progress_bar.dart';

class BudgetSection extends StatelessWidget {
  const BudgetSection({
    super.key,
    required this.profile,
    required this.transactions,
  });

  final UserProfile profile;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final expense = getMonthlyExpense(transactions, DateTime.now());
    final budget = profile.monthlyBudget;
    final remaining = budget - expense;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Bulanan',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text('${formatIDR(expense)} terpakai • sisa ${formatIDR(remaining)}'),
          const SizedBox(height: 10),
          ProgressBar(value: budget == 0 ? 0 : expense / budget),
          const SizedBox(height: 16),
          ...const [
            ('Makanan', 247500, 1000000),
            ('Transportasi', 110000, 500000),
            ('Belanja', 99000, 700000),
            ('Hiburan', 0, 300000),
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.$1}: ${formatIDR(item.$2)} / ${formatIDR(item.$3)}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  ProgressBar(value: item.$2 / item.$3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text('Masih aman, tapi pengeluaran makanan mulai cepat naik.'),
          const SizedBox(height: 12),
          AppButton(
            label: 'Atur Budget',
            icon: Icons.tune,
            isSecondary: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
