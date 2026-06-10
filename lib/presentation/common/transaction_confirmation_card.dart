import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/money_formatter.dart';
import '../../domain/models/category.dart';
import '../../domain/models/transaction.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_text_field.dart';

class TransactionConfirmationCard extends StatelessWidget {
  const TransactionConfirmationCard({
    super.key,
    required this.transaction,
    required this.onSave,
    required this.onCancel,
    required this.onEdited,
  });

  final Transaction transaction;
  final ValueChanged<Transaction> onSave;
  final VoidCallback onCancel;
  final ValueChanged<Transaction> onEdited;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.highlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🐱📋', style: TextStyle(fontSize: 28)),
          Text(
            'Cek dulu ya',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          _Line(
            'Jenis',
            transaction.type == TransactionType.income
                ? 'Pemasukan'
                : 'Pengeluaran',
          ),
          _Line('Kategori', transaction.category),
          _Line('Deskripsi', transaction.description),
          _Line('Nominal', formatIDR(transaction.amount)),
          _Line('Tanggal', formatIndonesianDate(transaction.transactionDate)),
          _Line(
            'Catatan',
            transaction.notes?.isNotEmpty == true ? transaction.notes! : '-',
          ),
          _Line('Sumber', transaction.source.name),
          _Line(
            'Akurasi',
            '${((transaction.confidenceScore ?? 0) * 100).round()}%',
          ),
          if ((transaction.confidenceScore ?? 1) < 0.75) ...[
            const SizedBox(height: 8),
            const Text(
              'Haro belum terlalu yakin, cek lagi ya.',
              style: TextStyle(
                color: AppColors.expense,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Simpan Transaksi',
                  icon: Icons.check,
                  onPressed: () => onSave(transaction),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: 'Edit',
                onPressed: () async {
                  final edited = await showModalBottomSheet<Transaction>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        _TransactionEditor(transaction: transaction),
                  );
                  if (edited != null) onEdited(edited);
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                tooltip: 'Batal',
                onPressed: onCancel,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(label, style: const TextStyle(color: AppColors.muted)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionEditor extends StatefulWidget {
  const _TransactionEditor({required this.transaction});

  final Transaction transaction;

  @override
  State<_TransactionEditor> createState() => _TransactionEditorState();
}

class _TransactionEditorState extends State<_TransactionEditor> {
  late TransactionType _type = widget.transaction.type;
  late final _categoryController = TextEditingController(
    text: widget.transaction.category,
  );
  late final _descriptionController = TextEditingController(
    text: widget.transaction.description,
  );
  late final _amountController = TextEditingController(
    text: widget.transaction.amount.toString(),
  );
  late final _notesController = TextEditingController(
    text: widget.transaction.notes ?? '',
  );
  late DateTime _date = widget.transaction.transactionDate;

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _type == TransactionType.income
        ? incomeCategories
        : expenseCategories;
    return Padding(
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
            'Edit transaksi',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<TransactionType>(
            initialValue: _type,
            items: const [
              DropdownMenuItem(
                value: TransactionType.expense,
                child: Text('Pengeluaran'),
              ),
              DropdownMenuItem(
                value: TransactionType.income,
                child: Text('Pemasukan'),
              ),
            ],
            onChanged: (value) => setState(() => _type = value ?? _type),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: categories.contains(_categoryController.text)
                ? _categoryController.text
                : categories.last,
            items: categories
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) =>
                _categoryController.text = value ?? _categoryController.text,
          ),
          const SizedBox(height: 12),
          AppTextField(controller: _descriptionController, hint: 'Deskripsi'),
          const SizedBox(height: 12),
          AppTextField(
            controller: _amountController,
            hint: 'Nominal',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          AppTextField(controller: _notesController, hint: 'Catatan'),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(formatIndonesianDate(_date)),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Simpan perubahan',
            onPressed: () {
              final amount =
                  parseIDRText(_amountController.text) ??
                  widget.transaction.amount;
              Navigator.pop(
                context,
                widget.transaction.copyWith(
                  type: _type,
                  amount: amount,
                  category: _categoryController.text,
                  description: _descriptionController.text,
                  transactionDate: _date,
                  notes: _notesController.text,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
