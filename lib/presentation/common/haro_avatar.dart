import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum HaroMoodVisual {
  happy,
  thinking,
  worried,
  proud,
  warning,
  celebrating,
  readingReceipt,
  sleeping,
}

class HaroAvatar extends StatelessWidget {
  const HaroAvatar({
    super.key,
    this.size = 56,
    this.mood = HaroMoodVisual.happy,
  });

  final double size;
  final HaroMoodVisual mood;

  String get _face {
    return switch (mood) {
      HaroMoodVisual.happy => '🐱',
      HaroMoodVisual.thinking => '🐱?',
      HaroMoodVisual.worried => '🙀',
      HaroMoodVisual.proud => '😼',
      HaroMoodVisual.warning => '🐱!',
      HaroMoodVisual.celebrating => '🐱🎉',
      HaroMoodVisual.readingReceipt => '🐱🧾',
      HaroMoodVisual.sleeping => '😴',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Avatar Haro',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.highlight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBrown.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(_face, style: TextStyle(fontSize: size * 0.38)),
        ),
      ),
    );
  }
}
