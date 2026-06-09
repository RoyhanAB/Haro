import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/money_formatter.dart';
import '../../domain/models/transaction.dart';

class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.transaction,
    this.onDelete,
    this.onEdit,
  });

  final Transaction transaction;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final color = transaction.type == TransactionType.income
        ? AppColors.income
        : AppColors.expense;
    final sign = transaction.type == TransactionType.income ? '+' : '-';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(
          transaction.type == TransactionType.income
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          color: color,
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        '${transaction.category} • ${formatIndonesianDate(transaction.transactionDate)}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$sign${formatIDR(transaction.amount)}',
            style: TextStyle(color: color, fontWeight: FontWeight.w900),
          ),
          if (onEdit != null || onDelete != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit?.call();
                if (value == 'delete') onDelete?.call();
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                if (onDelete != null)
                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
              ],
            ),
        ],
      ),
    );
  }
}
