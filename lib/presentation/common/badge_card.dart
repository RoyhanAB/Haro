import 'package:flutter/material.dart';

import 'app_card.dart';

class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key, required this.title, required this.locked});

  final String title;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(locked ? Icons.lock_outline : Icons.emoji_events, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
