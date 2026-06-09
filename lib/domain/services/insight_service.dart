import '../../core/utils/money_formatter.dart';
import '../models/transaction.dart';
import '../models/user_profile.dart';
import 'summary_service.dart';

String generateHaroInsight(
  UserProfile? profile,
  List<Transaction> transactions,
  DateTime month,
) {
  if (profile == null)
    return 'Lengkapi profil dulu supaya Haro bisa bantu jaga dompetmu.';
  final expense = getMonthlyExpense(transactions, month);
  final budget = profile.monthlyBudget;
  if (expense == 0)
    return 'Belum ada pengeluaran bulan ini. Mulai catat dari hal kecil seperti kopi atau ojek.';
  final breakdown = getCategoryBreakdown(transactions, month).entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final top = breakdown.first;
  if (budget > 0 && expense > budget * 0.8) {
    return 'Pengeluaran sudah ${formatIDR(expense)}. Yuk tahan dulu kategori ${top.key.toLowerCase()} biar sisa bulan tetap aman.';
  }
  return 'Kategori ${top.key.toLowerCase()} paling besar bulan ini: ${formatIDR(top.value)}. Haro bantu pantau terus, ya.';
}
