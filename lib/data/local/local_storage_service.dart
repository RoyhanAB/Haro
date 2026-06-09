import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/auth_user.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/user_profile.dart';

class LocalStorageService {
  static const _authUserKey = 'authUser';
  static const _authPasswordKey = 'authPassword';
  static const _onboardingKey = 'hasCompletedOnboarding';
  static const _setupKey = 'hasCompletedSetup';
  static const _profileKey = 'userProfile';
  static const _transactionsKey = 'transactions';
  static const _streakKey = 'streakDays';

  Future<AuthUser?> getAuthUser() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_authUserKey);
    if (value == null) return null;
    return AuthUser.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  Future<String?> getStoredPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authPasswordKey);
  }

  Future<void> saveAuthUser(AuthUser user, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authUserKey, jsonEncode(user.toJson()));
    await prefs.setString(_authPasswordKey, password);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authUserKey);
  }

  Future<bool> getOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }

  Future<bool> getSetupCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_setupKey) ?? false;
  }

  Future<void> setSetupCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_setupKey, value);
  }

  Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_profileKey);
    if (value == null) return null;
    return UserProfile.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_transactionsKey);
    if (value == null) return [];
    final list = jsonDecode(value) as List<dynamic>;
    return list
        .map((item) => Transaction.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _transactionsKey,
      jsonEncode(transactions.map((item) => item.toJson()).toList()),
    );
  }

  Future<int> getStreakDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  Future<void> setStreakDays(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_streakKey, value);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authUserKey);
    await prefs.remove(_authPasswordKey);
    await prefs.remove(_onboardingKey);
    await prefs.remove(_setupKey);
    await prefs.remove(_profileKey);
    await prefs.remove(_transactionsKey);
    await prefs.remove(_streakKey);
  }
}
