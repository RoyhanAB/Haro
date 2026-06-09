import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/id_generator.dart';
import '../../domain/models/transaction.dart';
import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/app_card.dart';
import '../common/app_screen.dart';
import '../common/money_text.dart';
import '../common/transaction_confirmation_card.dart';

class ScanReceiptScreen extends ConsumerStatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  ConsumerState<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends ConsumerState<ScanReceiptScreen> {
  bool _processing = false;
  Transaction? _mockTransaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScreen(
        children: [
          Text(
            'Scan Struk',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text('Foto struknya, nanti aku endus totalnya.'),
          const SizedBox(height: 16),
          AppCard(
            child: SizedBox(
              height: 180,
              child: Center(
                child: _processing
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Haro sedang membaca struk...'),
                        ],
                      )
                    : const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long, size: 64),
                          SizedBox(height: 8),
                          Text('Area foto atau upload struk'),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Ambil Foto',
                  icon: Icons.camera_alt,
                  onPressed: _mockScan,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Upload dari Galeri',
                  icon: Icons.photo,
                  isSecondary: true,
                  onPressed: _mockScan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_mockTransaction != null) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hasil baca struk',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text('Merchant: Alfamart'),
                  const Text('Kategori: Belanja'),
                  const Text(
                    'Item: Roti Rp12.000, Susu Rp18.000, Snack Rp9.500, Lainnya Rp33.000',
                  ),
                  const SizedBox(height: 8),
                  MoneyText(
                    _mockTransaction!.amount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TransactionConfirmationCard(
              transaction: _mockTransaction!,
              onSave: (transaction) async {
                await ref
                    .read(appStateProvider.notifier)
                    .addTransaction(transaction);
                setState(() => _mockTransaction = null);
              },
              onCancel: () => setState(() => _mockTransaction = null),
              onEdited: (transaction) =>
                  setState(() => _mockTransaction = transaction),
            ),
          ],
          const SizedBox(height: 16),
          const Text(
            'TODO: integrasi camera, Google ML Kit OCR, AI vision, dan Supabase setelah MVP offline stabil.',
          ),
        ],
      ),
    );
  }

  Future<void> _mockScan() async {
    setState(() {
      _processing = true;
      _mockTransaction = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    setState(() {
      _processing = false;
      _mockTransaction = Transaction(
        id: generateId(),
        type: TransactionType.expense,
        amount: 72500,
        currency: 'IDR',
        category: 'Belanja',
        description: 'Belanja Alfamart',
        merchant: 'Alfamart',
        transactionDate: now,
        source: TransactionSource.receipt,
        confidenceScore: 0.82,
        createdAt: now,
        updatedAt: now,
      );
    });
  }
}
