import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money_formatter.dart';
import '../../domain/models/parsed_transaction_result.dart';
import '../../domain/models/transaction.dart';
import '../../domain/services/insight_service.dart';
import '../../domain/services/summary_service.dart';
import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/app_text_field.dart';
import '../common/haro_avatar.dart';
import '../common/empty_state.dart';
import '../common/insight_card.dart';
import '../common/money_text.dart';
import '../common/progress_bar.dart';
import '../common/transaction_confirmation_card.dart';
import '../common/transaction_row.dart';
import '../history/transaction_history_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _quickInput = TextEditingController();
  Transaction? _pending;
  String? _assistantMessage;

  @override
  void dispose() {
    _quickInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final profile = state.userProfile!;
    final now = DateTime.now();
    final income = getMonthlyIncome(state.transactions, now);
    final expense = getMonthlyExpense(state.transactions, now);
    final remaining = getMonthlyRemaining(profile, state.transactions, now);
    final budgetBase = profile.monthlyBudget == 0
        ? (profile.monthlyIncome ?? 0)
        : profile.monthlyBudget;
    final progress = budgetBase == 0 ? 0.0 : expense / budgetBase;

    return Scaffold(
      body: AppScreen(
        children: [
          Row(
            children: [
              const HaroAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${profile.name}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const Text('Haro siap bantu jaga dompetmu.'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            color: AppColors.highlight,
            child: Row(
              children: [
                const HaroAvatar(size: 44, mood: HaroMoodVisual.happy),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mau catat apa hari ini?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
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
              children: [
                const Text(
                  'Sisa uang bulan ini',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                MoneyText(
                  remaining,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  progress < 0.8
                      ? 'Aman sampai akhir bulan'
                      : 'Mulai hati-hati, pengeluaran cepat naik',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'Pemasukan bulan ini',
                  amount: income,
                  color: AppColors.income,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Pengeluaran bulan ini',
                  amount: expense,
                  color: AppColors.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatIDR(expense)} dari ${formatIDR(budgetBase)} terpakai',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ProgressBar(value: progress),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                AppTextField(
                  controller: _quickInput,
                  hint: 'Contoh: beli cilok 10 ribu',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Catat',
                        icon: Icons.send,
                        onPressed: _parseQuickInput,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Scan struk',
                      onPressed: () {},
                      icon: const Icon(Icons.document_scanner),
                    ),
                  ],
                ),
                if (_assistantMessage != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_assistantMessage!),
                  ),
                ],
              ],
            ),
          ),
          if (_pending != null) ...[
            const SizedBox(height: 12),
            TransactionConfirmationCard(
              transaction: _pending!,
              onSave: (transaction) async {
                await ref
                    .read(appStateProvider.notifier)
                    .addTransaction(transaction);
                setState(() {
                  _pending = null;
                  _assistantMessage = 'Meong~ transaksi berhasil disimpan.';
                  _quickInput.clear();
                });
              },
              onCancel: () => setState(() => _pending = null),
              onEdited: (transaction) => setState(() => _pending = transaction),
            ),
          ],
          const SizedBox(height: 16),
          InsightCard(
            text: generateHaroInsight(profile, state.transactions, now),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Transaksi terbaru',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TransactionHistoryScreen(),
                  ),
                ),
                child: const Text('Lihat semua'),
              ),
            ],
          ),
          if (state.transactions.isEmpty)
            const EmptyState(
              title: 'Belum ada transaksi',
              body: 'Coba tulis "beli kopi 22.500" untuk mulai.',
            )
          else
            ...state.transactions
                .take(5)
                .map((item) => TransactionRow(transaction: item)),
        ],
      ),
    );
  }

  void _parseQuickInput() {
    final result = ref.read(transactionParserProvider).parse(_quickInput.text);
    setState(() {
      _assistantMessage = result.assistantMessage;
      _pending = result.intent == ParsedIntent.createTransaction
          ? result.transaction
          : null;
    });
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          MoneyText(
            amount,
            color: color,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
