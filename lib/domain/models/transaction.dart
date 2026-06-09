enum TransactionType { income, expense }

enum TransactionSource { chat, receipt, manual }

class Transaction {
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.category,
    required this.description,
    required this.transactionDate,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.merchant,
    this.rawInput,
    this.confidenceScore,
    this.notes,
  });

  final String id;
  final String? userId;
  final TransactionType type;
  final int amount;
  final String currency;
  final String category;
  final String description;
  final String? merchant;
  final DateTime transactionDate;
  final TransactionSource source;
  final String? rawInput;
  final double? confidenceScore;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction copyWith({
    String? userId,
    TransactionType? type,
    int? amount,
    String? category,
    String? description,
    String? merchant,
    DateTime? transactionDate,
    TransactionSource? source,
    String? rawInput,
    double? confidenceScore,
    String? notes,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency,
      category: category ?? this.category,
      description: description ?? this.description,
      merchant: merchant ?? this.merchant,
      transactionDate: transactionDate ?? this.transactionDate,
      source: source ?? this.source,
      rawInput: rawInput ?? this.rawInput,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'type': type.name,
    'amount': amount,
    'currency': currency,
    'category': category,
    'description': description,
    'merchant': merchant,
    'transactionDate': transactionDate.toIso8601String(),
    'source': source.name,
    'rawInput': rawInput,
    'confidenceScore': confidenceScore,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    userId: json['userId'] as String?,
    type: TransactionType.values.firstWhere(
      (type) => type.name == json['type'],
    ),
    amount: json['amount'] as int,
    currency: json['currency'] as String? ?? 'IDR',
    category: json['category'] as String,
    description: json['description'] as String,
    merchant: json['merchant'] as String?,
    transactionDate: DateTime.parse(json['transactionDate'] as String),
    source: TransactionSource.values.firstWhere(
      (source) => source.name == json['source'],
    ),
    rawInput: json['rawInput'] as String?,
    confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}
