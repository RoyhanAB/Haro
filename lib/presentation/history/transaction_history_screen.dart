import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/models/transaction.dart';
import '../../state/app_providers.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/empty_state.dart';
import '../common/filter_chip.dart';
import '../common/transaction_confirmation_card.dart';
import '../common/transaction_row.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final _search = TextEditingController();
  String _filter = 'Semua';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref
        .watch(appStateProvider)
        .transactions
        .where(_matches)
        .toList();
    final groups = <String, List<Transaction>>{};
    for (final item in transactions) {
      groups
          .putIfAbsent(formatIndonesianDate(item.transactionDate), () => [])
          .add(item);
    }
    return Scaffold(
      body: AppScreen(
        children: [
          Text(
            'Riwayat Transaksi',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _search,
            decoration: const InputDecoration(hintText: 'Cari transaksi...'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children:
                [
                      'Semua',
                      'Pengeluaran',
                      'Pemasukan',
                      'Makanan',
                      'Transportasi',
                      'Belanja',
                    ]
                    .map(
                      (item) => HaroFilterChip(
                        label: item,
                        selected: _filter == item,
                        onSelected: (_) => setState(() => _filter = item),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 12),
          if (transactions.isEmpty)
            const EmptyState(
              title: 'Belum ada riwayat',
              body: 'Transaksi yang disimpan akan muncul di sini.',
            )
          else
            ...groups.entries.map(
              (entry) => AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    ...entry.value.map(
                      (item) => TransactionRow(
                        transaction: item,
                        onEdit: () => _edit(item),
                        onDelete: () => _delete(item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _matches(Transaction item) {
    final query = _search.text.toLowerCase();
    final filterOk =
        _filter == 'Semua' ||
        (_filter == 'Pengeluaran' && item.type == TransactionType.expense) ||
        (_filter == 'Pemasukan' && item.type == TransactionType.income) ||
        item.category == _filter;
    final queryOk =
        query.isEmpty ||
        item.description.toLowerCase().contains(query) ||
        item.category.toLowerCase().contains(query);
    return filterOk && queryOk;
  }

  Future<void> _delete(Transaction transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text('Transaksi "${transaction.description}" akan dihapus.'),
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
      ref.read(appStateProvider.notifier).deleteTransaction(transaction.id);
    }
  }

  Future<void> _edit(Transaction transaction) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: TransactionConfirmationCard(
          transaction: transaction,
          onSave: (updated) {
            ref
                .read(appStateProvider.notifier)
                .updateTransaction(transaction.id, updated);
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
          onEdited: (updated) {
            ref
                .read(appStateProvider.notifier)
                .updateTransaction(transaction.id, updated);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
