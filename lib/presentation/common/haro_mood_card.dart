import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'haro_avatar.dart';
import 'haro_speech_bubble.dart';

class HaroMoodCard extends StatelessWidget {
  const HaroMoodCard({
    super.key,
    required this.label,
    required this.message,
    this.mood = HaroMoodVisual.happy,
    this.onAction,
  });

  final String label;
  final String message;
  final HaroMoodVisual mood;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.softPeach,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HaroAvatar(size: 82, mood: mood),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          HaroSpeechBubble(text: message),
          if (onAction != null) ...[
            const SizedBox(height: 12),
            AppButton(label: 'Lihat saran Haro', onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
