enum HaroTone { lucu, santai, tegas }

class UserProfile {
  const UserProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.currency,
    required this.monthlyBudget,
    required this.haroTone,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.monthlyIncome,
    this.payday,
  });

  final String id;
  final String userId;
  final String name;
  final String? email;
  final String currency;
  final int monthlyBudget;
  final int? monthlyIncome;
  final int? payday;
  final HaroTone haroTone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? name,
    String? email,
    int? monthlyBudget,
    int? monthlyIncome,
    int? payday,
    HaroTone? haroTone,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      userId: userId,
      name: name ?? this.name,
      email: email ?? this.email,
      currency: currency,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      payday: payday ?? this.payday,
      haroTone: haroTone ?? this.haroTone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'email': email,
    'currency': currency,
    'monthlyBudget': monthlyBudget,
    'monthlyIncome': monthlyIncome,
    'payday': payday,
    'haroTone': haroTone.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    userId: json['userId'] as String? ?? json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String?,
    currency: json['currency'] as String? ?? 'IDR',
    monthlyBudget: json['monthlyBudget'] as int? ?? 0,
    monthlyIncome: json['monthlyIncome'] as int?,
    payday: json['payday'] as int?,
    haroTone: HaroTone.values.firstWhere(
      (tone) => tone.name == (json['haroTone'] ?? json['HaroTone']),
      orElse: () => HaroTone.lucu,
    ),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}
