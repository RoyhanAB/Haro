import 'package:flutter/material.dart';

import 'app_card.dart';
import 'haro_avatar.dart';
import 'haro_speech_bubble.dart';

class HaroHero extends StatelessWidget {
  const HaroHero({
    super.key,
    required this.title,
    required this.message,
    this.mood = HaroMoodVisual.happy,
  });

  final String title;
  final String message;
  final HaroMoodVisual mood;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          HaroAvatar(size: 132, mood: mood),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          HaroSpeechBubble(text: message),
        ],
      ),
    );
  }
}
