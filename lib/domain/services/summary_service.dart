import '../../core/utils/date_utils.dart';
import '../models/transaction.dart';
import '../models/user_profile.dart';

int getMonthlyIncome(List<Transaction> transactions, DateTime month) =>
    transactions
        .where(
          (item) =>
              item.type == TransactionType.income &&
              isSameMonth(item.transactionDate, month),
        )
        .fold(0, (total, item) => total + item.amount);

int getMonthlyExpense(List<Transaction> transactions, DateTime month) =>
    transactions
        .where(
          (item) =>
              item.type == TransactionType.expense &&
              isSameMonth(item.transactionDate, month),
        )
        .fold(0, (total, item) => total + item.amount);

int getMonthlyRemaining(
  UserProfile profile,
  List<Transaction> transactions,
  DateTime month,
) {
  final base = (profile.monthlyIncome ?? 0) > 0
      ? profile.monthlyIncome!
      : profile.monthlyBudget;
  return base +
      getMonthlyIncome(transactions, month) -
      getMonthlyExpense(transactions, month);
}

Map<String, int> getCategoryBreakdown(
  List<Transaction> transactions,
  DateTime month,
) {
  final result = <String, int>{};
  for (final item in transactions.where(
    (item) =>
        item.type == TransactionType.expense &&
        isSameMonth(item.transactionDate, month),
  )) {
    result[item.category] = (result[item.category] ?? 0) + item.amount;
  }
  return result;
}

int calculateDailySafeSpending(
  UserProfile profile,
  List<Transaction> transactions,
  DateTime month,
) {
  final remaining = getMonthlyRemaining(profile, transactions, month);
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final remainingDays = (daysInMonth - month.day + 1).clamp(1, 31);
  return remaining <= 0 ? 0 : (remaining / remainingDays).floor();
}
