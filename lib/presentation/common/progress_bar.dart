import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        minHeight: 10,
        value: value.clamp(0, 1),
        backgroundColor: AppColors.highlight,
        color: value > 0.85 ? AppColors.expense : AppColors.primary,
      ),
    );
  }
}
