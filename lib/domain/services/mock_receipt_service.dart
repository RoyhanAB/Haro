import '../../core/utils/id_generator.dart';
import '../models/receipt_item.dart';
import '../models/transaction.dart';

class MockReceiptResult {
  const MockReceiptResult({required this.transaction, required this.items});

  final Transaction transaction;
  final List<ReceiptItem> items;
}

class MockReceiptService {
  Future<MockReceiptResult> extract() async {
    // TODO: Replace with camera capture, Google ML Kit OCR, and AI vision.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    final transactionId = generateId();
    return MockReceiptResult(
      transaction: Transaction(
        id: transactionId,
        type: TransactionType.expense,
        amount: 72500,
        currency: 'IDR',
        category: 'Belanja',
        description: 'Belanja Alfamart',
        merchant: 'Alfamart',
        transactionDate: now,
        source: TransactionSource.receipt,
        confidenceScore: 0.88,
        createdAt: now,
        updatedAt: now,
      ),
      items: [
        ReceiptItem(
          id: generateId(),
          transactionId: transactionId,
          itemName: 'Roti',
          price: 12000,
        ),
        ReceiptItem(
          id: generateId(),
          transactionId: transactionId,
          itemName: 'Susu',
          price: 18000,
        ),
        ReceiptItem(
          id: generateId(),
          transactionId: transactionId,
          itemName: 'Snack',
          price: 9500,
        ),
        ReceiptItem(
          id: generateId(),
          transactionId: transactionId,
          itemName: 'Lainnya',
          price: 33000,
        ),
      ],
    );
  }
}
