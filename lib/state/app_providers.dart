import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/local_storage_service.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../domain/models/auth_user.dart';
import '../domain/models/transaction.dart';
import '../domain/models/user_profile.dart';
import '../domain/services/transaction_parser_service.dart';
import 'app_state.dart';

final localStorageProvider = Provider((ref) => LocalStorageService());
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(ref.read(localStorageProvider)),
);
final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(ref.read(localStorageProvider)),
);
final transactionRepositoryProvider = Provider(
  (ref) => TransactionRepository(ref.read(localStorageProvider)),
);
final transactionParserProvider = Provider((ref) => TransactionParserService());

final appStateProvider = StateNotifierProvider<AppController, AppState>((ref) {
  return AppController(
    storage: ref.read(localStorageProvider),
    authRepository: ref.read(authRepositoryProvider),
    profileRepository: ref.read(profileRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
  );
});

class AppController extends StateNotifier<AppState> {
  AppController({
    required LocalStorageService storage,
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required TransactionRepository transactionRepository,
  }) : _storage = storage,
       _authRepository = authRepository,
       _profileRepository = profileRepository,
       _transactionRepository = transactionRepository,
       super(AppState.initial());

  final LocalStorageService _storage;
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  final TransactionRepository _transactionRepository;

  Future<void> hydrate() async {
    final authUser = await _authRepository.getSession();
    final hasCompletedOnboarding = await _storage.getOnboardingCompleted();
    final hasCompletedSetup = await _storage.getSetupCompleted();
    final profile = await _profileRepository.getProfile();
    final transactions = await _transactionRepository.getTransactions();
    final streakDays = await _storage.getStreakDays();
    transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    state = state.copyWith(
      isHydrated: true,
      authUser: authUser,
      hasCompletedOnboarding: hasCompletedOnboarding,
      hasCompletedSetup: hasCompletedSetup,
      userProfile: profile,
      transactions: transactions,
      streakDays: streakDays,
    );
  }

  Future<bool> login(String email, String password) async {
    final user = await _authRepository.login(email: email, password: password);
    if (user == null) return false;
    state = state.copyWith(authUser: user);
    return true;
  }

  Future<void> register(String name, String email, String password) async {
    final user = await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );
    state = state.copyWith(authUser: user);
  }

  Future<void> forgotPassword(String email) => _authRepository.forgotPassword(email);

  Future<void> logout() async {
    await _authRepository.logout();
    state = state.copyWith(clearAuthUser: true);
  }

  Future<void> completeOnboarding() async {
    await _storage.setOnboardingCompleted(true);
    state = state.copyWith(hasCompletedOnboarding: true);
  }

  Future<void> setProfile(UserProfile profile) async {
    await _profileRepository.saveProfile(profile);
    await _storage.setSetupCompleted(true);
    state = state.copyWith(userProfile: profile, hasCompletedSetup: true);
  }

  Future<void> updateProfile(UserProfile profile) =>
      setProfile(profile.copyWith(updatedAt: DateTime.now()));

  Future<void> addTransaction(Transaction transaction) async {
    final withUser = transaction.copyWith(userId: state.authUser?.id);
    final transactions = [withUser, ...state.transactions]
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    await _transactionRepository.saveTransactions(transactions);
    final nextStreak = state.streakDays == 0 ? 1 : state.streakDays;
    await _storage.setStreakDays(nextStreak);
    state = state.copyWith(transactions: transactions, streakDays: nextStreak);
  }

  Future<void> updateTransaction(
    String id,
    Transaction updatedTransaction,
  ) async {
    final transactions =
        state.transactions
            .map(
              (item) => item.id == id
                  ? updatedTransaction.copyWith(updatedAt: DateTime.now())
                  : item,
            )
            .toList()
          ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    await _transactionRepository.saveTransactions(transactions);
    state = state.copyWith(transactions: transactions);
  }

  Future<void> deleteTransaction(String id) async {
    final transactions = state.transactions
        .where((item) => item.id != id)
        .toList();
    await _transactionRepository.saveTransactions(transactions);
    state = state.copyWith(transactions: transactions);
  }

  Future<void> clearAllData() async {
    await _storage.clearAll();
    state = AppState.initial().copyWith(isHydrated: true);
  }
}
