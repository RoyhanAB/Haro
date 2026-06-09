import '../../core/utils/id_generator.dart';
import '../../core/utils/money_formatter.dart';
import '../models/parsed_transaction_result.dart';
import '../models/transaction.dart';

class TransactionParserService {
  ParsedTransactionResult parse(String input, {DateTime? now}) {
    final clock = now ?? DateTime.now();
    final raw = input.trim();
    final text = raw.toLowerCase();
    final amount = _extractAmount(text);

    if (amount == null) {
      return const ParsedTransactionResult(
        intent: ParsedIntent.askQuestion,
        needsConfirmation: false,
        assistantMessage: 'Meong~ nominalnya berapa, Roy?',
        missingFields: ['amount'],
        confidenceScore: 0,
      );
    }

    final type = _inferType(text);
    if (type == null) {
      return const ParsedTransactionResult(
        intent: ParsedIntent.askQuestion,
        needsConfirmation: false,
        assistantMessage: 'Ini pemasukan atau pengeluaran, ya?',
        missingFields: ['type'],
        confidenceScore: 0,
      );
    }

    final category = _inferCategory(text, type);
    final date = _inferDate(text, clock);
    final description = _inferDescription(text, category, type);
    final lowConfidence = category == 'Lainnya' || text.contains('besok');
    final transaction = Transaction(
      id: generateId(),
      type: type,
      amount: amount,
      currency: 'IDR',
      category: category,
      description: description,
      transactionDate: date,
      source: TransactionSource.chat,
      rawInput: raw,
      confidenceScore: lowConfidence ? 0.66 : 0.9,
      createdAt: clock,
      updatedAt: clock,
    );

    return ParsedTransactionResult(
      intent: ParsedIntent.createTransaction,
      transaction: transaction,
      needsConfirmation: true,
      assistantMessage: _message(transaction),
      missingFields: const [],
      confidenceScore: transaction.confidenceScore ?? 0.9,
    );
  }

  int? _extractAmount(String text) {
    final multiplierPattern = RegExp(
      r'(\d+(?:[,.]\d+)?)\s*(ribu|rb|k|juta|jt)\b',
    );
    for (final match in multiplierPattern.allMatches(text)) {
      final number = double.tryParse(match.group(1)!.replaceAll(',', '.'));
      if (number == null) continue;
      final unit = match.group(2)!;
      final multiplier = unit == 'juta' || unit == 'jt' ? 1000000 : 1000;
      return (number * multiplier).round();
    }

    final numberPattern = RegExp(r'\b\d{1,3}(?:[,.]\d{3})+\b|\b\d{4,}\b');
    final match = numberPattern.firstMatch(text);
    if (match == null) return null;
    final token = match.group(0)!.replaceAll(RegExp(r'[,.]'), '');
    return int.tryParse(token);
  }

  TransactionType? _inferType(String text) {
    const incomeKeywords = [
      'gajian',
      'gaji',
      'salary',
      'dapet',
      'dapat',
      'masuk',
      'bonus',
      'freelance',
      'transferan',
      'dibayar',
      'pendapatan',
    ];
    const expenseKeywords = [
      'beli',
      'bayar',
      'jajan',
      'makan',
      'minum',
      'naik',
      'pesen',
      'order',
      'belanja',
      'langganan',
      'top up',
      'isi bensin',
      'ngopi',
      'cilok',
      'ojek',
      'kos',
      'sewa',
    ];
    if (incomeKeywords.any(text.contains)) return TransactionType.income;
    if (expenseKeywords.any(text.contains)) return TransactionType.expense;
    return null;
  }

  String _inferCategory(String text, TransactionType type) {
    final rules = <String, List<String>>{
      'Makanan': [
        'cilok',
        'nasi',
        'makan',
        'kopi',
        'minum',
        'roti',
        'snack',
        'martabak',
        'ayam',
        'bakso',
        'mie',
      ],
      'Transportasi': [
        'ojek',
        'gojek',
        'grab',
        'bensin',
        'parkir',
        'tol',
        'bus',
        'kereta',
        'angkot',
      ],
      'Belanja': [
        'alfamart',
        'indomaret',
        'belanja',
        'supermarket',
        'toko',
        'baju',
        'sepatu',
      ],
      'Tagihan': [
        'listrik',
        'air',
        'internet',
        'wifi',
        'pulsa',
        'paket data',
        'langganan',
      ],
      'Kos': ['kos', 'kontrakan', 'sewa'],
      'Kesehatan': ['dokter', 'obat', 'klinik', 'rumah sakit'],
      'Pendidikan': ['sekolah', 'kuliah', 'buku', 'kursus'],
      'Gaji': ['gajian', 'gaji', 'salary'],
      'Freelance': ['freelance', 'project', 'client', 'dibayar client'],
      'Bonus': ['bonus'],
    };
    for (final entry in rules.entries) {
      if (entry.value.any(text.contains)) return entry.key;
    }
    return 'Lainnya';
  }

  DateTime _inferDate(String text, DateTime now) {
    if (text.contains('kemarin') || text.contains('semalam')) {
      return now.subtract(const Duration(days: 1));
    }
    if (text.contains('besok')) return now.add(const Duration(days: 1));
    return now;
  }

  String _inferDescription(String text, String category, TransactionType type) {
    final keywords = [
      'cilok',
      'gajian',
      'bayar kos',
      'kos',
      'ojek',
      'kopi',
      'bonus',
      'martabak',
      'freelance',
      'belanja',
      'bensin',
    ];
    final found = keywords.firstWhere(
      (word) => text.contains(word),
      orElse: () => category.toLowerCase(),
    );
    return found
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  String _message(Transaction transaction) {
    final amount = formatIDR(transaction.amount);
    if (transaction.type == TransactionType.income) {
      return 'Mantap! ${transaction.description} $amount masuk. Aku simpan sebagai pemasukan?';
    }
    return 'Meong~ aku tangkap ini sebagai pengeluaran ${transaction.category.toLowerCase()} $amount untuk ${transaction.description.toLowerCase()}. Simpan?';
  }
}
