import 'package:intl/intl.dart';

final _idrFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

String formatIDR(int amount) =>
    _idrFormatter.format(amount).replaceAll(',00', '');

int? parseIDRText(String text) {
  final cleaned = text.trim().replaceAll(RegExp(r'[^0-9]'), '');
  if (cleaned.isEmpty) return null;
  return int.tryParse(cleaned);
}
