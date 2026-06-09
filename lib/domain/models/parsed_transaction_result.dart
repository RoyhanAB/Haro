import 'transaction.dart';

enum ParsedIntent { createTransaction, askQuestion, unknown }

class ParsedTransactionResult {
  const ParsedTransactionResult({
    required this.intent,
    required this.needsConfirmation,
    required this.assistantMessage,
    required this.missingFields,
    required this.confidenceScore,
    this.transaction,
  });

  final ParsedIntent intent;
  final Transaction? transaction;
  final bool needsConfirmation;
  final String assistantMessage;
  final List<String> missingFields;
  final double confidenceScore;
}
