import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../common/app_screen.dart';
import '../common/badge_card.dart';
import '../common/haro_hero.dart';
import '../common/progress_bar.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(appStateProvider).streakDays;
    const badges = [
      'Rajin Catat',
      'Anti Kalap',
      'Budget Aman',
      'Jajan Terkendali',
      'Scan Master',
      'Gajian Terdeteksi',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Pencapaian')),
      body: AppScreen(
        children: [
          HaroHero(
            title: '$streak Hari',
            message: 'Catat 2 hari lagi untuk buka badge baru.',
          ),
          const SizedBox(height: 16),
          ProgressBar(value: (streak % 7) / 7),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (var i = 0; i < badges.length; i++)
                BadgeCard(title: badges[i], locked: i > streak),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tantangan minggu ini: Catat semua pengeluaran makan minggu ini.',
          ),
        ],
      ),
    );
  }
}
