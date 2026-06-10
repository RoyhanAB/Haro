import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/app_providers.dart';
import '../common/app_button.dart';
import '../common/haro_avatar.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _slides = const [
    (
      'Catat uangmu semudah ngobrol',
      'Tulis aja: "beli cilok 10 ribu", nanti Haro bantu catat otomatis.',
      '🪙',
    ),
    (
      'Scan struk, langsung rapi',
      'Foto struk belanja, Haro akan membaca total, toko, tanggal, dan itemnya.',
      '🧾',
    ),
    (
      'Tanya kondisi uangmu kapan aja',
      'Cek pengeluaran, sisa budget, dan insight bulanan lewat chat.',
      '📊',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HaroAvatar(
                          size: 132,
                          mood: index == 0
                              ? HaroMoodVisual.happy
                              : index == 1
                              ? HaroMoodVisual.readingReceipt
                              : HaroMoodVisual.warning,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide.$1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide.$2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => Container(
                    margin: const EdgeInsets.all(4),
                    width: _index == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: _index == i ? 1 : 0.3,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: _index == _slides.length - 1 ? 'Mulai' : 'Lanjut',
                onPressed: () {
                  if (_index == _slides.length - 1) {
                    ref.read(appStateProvider.notifier).completeOnboarding();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
