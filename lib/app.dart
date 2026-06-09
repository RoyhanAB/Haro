import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'presentation/main_shell.dart';
import 'presentation/onboarding/onboarding_screen.dart';
import 'presentation/onboarding/setup_profile_screen.dart';
import 'state/app_providers.dart';

class HAROApp extends ConsumerStatefulWidget {
  const HAROApp({super.key});

  @override
  ConsumerState<HAROApp> createState() => _HAROAppState();
}

class _HAROAppState extends ConsumerState<HAROApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(appStateProvider.notifier).hydrate());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);

    return MaterialApp(
      title: 'HARO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: !state.isHydrated
            ? const _SplashScreen()
            : !state.hasCompletedOnboarding
            ? const OnboardingScreen()
            : state.userProfile == null
            ? const SetupProfileScreen()
            : const MainShell(),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🐱', style: TextStyle(fontSize: 72)),
            SizedBox(height: 16),
            Text(
              'HARO',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text('Catat uangmu semudah ngobrol.'),
          ],
        ),
      ),
    );
  }
}
