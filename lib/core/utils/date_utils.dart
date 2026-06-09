import 'package:intl/intl.dart';

bool isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatIndonesianDate(DateTime date) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  if (isSameDay(date, now)) return 'Hari ini';
  if (isSameDay(date, yesterday)) return 'Kemarin';
  return DateFormat('d MMMM yyyy', 'id_ID').format(date);
}
