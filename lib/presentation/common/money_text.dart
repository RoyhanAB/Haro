import 'package:flutter/material.dart';

import '../../core/utils/money_formatter.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(this.amount, {super.key, this.style, this.color});

  final int amount;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatIDR(amount),
      style: (style ?? Theme.of(context).textTheme.titleMedium)?.copyWith(
        color: color,
      ),
    );
  }
}
