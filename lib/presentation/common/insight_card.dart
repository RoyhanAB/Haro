import 'package:flutter/material.dart';

import 'app_card.dart';
import 'haro_avatar.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HaroAvatar(size: 48, accessory: '📊'),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
