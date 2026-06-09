import 'package:HARO/domain/models/parsed_transaction_result.dart';
import 'package:HARO/domain/models/transaction.dart';
import 'package:HARO/domain/services/transaction_parser_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = TransactionParserService();
  final now = DateTime(2026, 6, 10, 10);

  test('parses cilok expense', () {
    final result = parser.parse('saya abis beli cilok 10 ribu', now: now);
    expect(result.intent, ParsedIntent.createTransaction);
    expect(result.transaction!.type, TransactionType.expense);
    expect(result.transaction!.amount, 10000);
    expect(result.transaction!.category, 'Makanan');
    expect(result.transaction!.description, 'Cilok');
  });

  test('parses gajian income', () {
    final result = parser.parse('tadi abis gajian 3jt', now: now);
    expect(result.transaction!.type, TransactionType.income);
    expect(result.transaction!.amount, 3000000);
    expect(result.transaction!.category, 'Gaji');
  });

  test('parses bayar kos decimal juta', () {
    final result = parser.parse('bayar kos 1,5 juta', now: now);
    expect(result.transaction!.type, TransactionType.expense);
    expect(result.transaction!.amount, 1500000);
    expect(result.transaction!.category, 'Kos');
  });

  test('parses yesterday ojek', () {
    final result = parser.parse('kemarin naik ojek 18rb', now: now);
    expect(result.transaction!.type, TransactionType.expense);
    expect(result.transaction!.amount, 18000);
    expect(result.transaction!.category, 'Transportasi');
    expect(result.transaction!.transactionDate.day, 9);
  });

  test('parses formatted kopi amount', () {
    final result = parser.parse('beli kopi 22.500', now: now);
    expect(result.transaction!.type, TransactionType.expense);
    expect(result.transaction!.amount, 22500);
    expect(result.transaction!.category, 'Makanan');
  });

  test('parses bonus income', () {
    final result = parser.parse('dapet bonus 500 ribu', now: now);
    expect(result.transaction!.type, TransactionType.income);
    expect(result.transaction!.amount, 500000);
    expect(result.transaction!.category, 'Bonus');
  });

  test('asks for missing amount', () {
    final result = parser.parse('beli martabak', now: now);
    expect(result.intent, ParsedIntent.askQuestion);
    expect(result.missingFields, contains('amount'));
  });
}
