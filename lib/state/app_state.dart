import '../domain/models/auth_user.dart';
import '../domain/models/transaction.dart';
import '../domain/models/user_profile.dart';

class AppState {
  const AppState({
    required this.isHydrated,
    required this.hasCompletedOnboarding,
    required this.hasCompletedSetup,
    required this.transactions,
    required this.streakDays,
    this.authUser,
    this.userProfile,
  });

  final bool isHydrated;
  final AuthUser? authUser;
  final bool hasCompletedOnboarding;
  final bool hasCompletedSetup;
  final UserProfile? userProfile;
  final List<Transaction> transactions;
  final int streakDays;

  bool get isLoggedIn => authUser != null;

  factory AppState.initial() => const AppState(
    isHydrated: false,
    hasCompletedOnboarding: false,
    hasCompletedSetup: false,
    transactions: [],
    streakDays: 0,
  );

  AppState copyWith({
    bool? isHydrated,
    AuthUser? authUser,
    bool clearAuthUser = false,
    bool? hasCompletedOnboarding,
    bool? hasCompletedSetup,
    UserProfile? userProfile,
    bool clearProfile = false,
    List<Transaction>? transactions,
    int? streakDays,
  }) {
    return AppState(
      isHydrated: isHydrated ?? this.isHydrated,
      authUser: clearAuthUser ? null : authUser ?? this.authUser,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      hasCompletedSetup: hasCompletedSetup ?? this.hasCompletedSetup,
      userProfile: clearProfile ? null : userProfile ?? this.userProfile,
      transactions: transactions ?? this.transactions,
      streakDays: streakDays ?? this.streakDays,
    );
  }
}
