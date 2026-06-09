import '../../core/utils/id_generator.dart';
import '../../domain/models/auth_user.dart';
import '../local/local_storage_service.dart';

class AuthRepository {
  AuthRepository(this._storage);

  final LocalStorageService _storage;

  Future<AuthUser?> getSession() => _storage.getAuthUser();

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = AuthUser(
      id: generateId(),
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    await _storage.saveAuthUser(user, password);
    return user;
  }

  Future<AuthUser?> login({
    required String email,
    required String password,
  }) async {
    final saved = await _storage.getAuthUser();
    final savedPassword = await _storage.getStoredPassword();
    if (saved != null &&
        saved.email.toLowerCase() == email.toLowerCase() &&
        savedPassword == password) {
      return saved;
    }
    if (email.toLowerCase() == 'demo@haro.app' && password == 'haro123') {
      final demo = AuthUser(
        id: 'demo-user',
        name: 'Roy',
        email: 'demo@haro.app',
        createdAt: DateTime.now(),
      );
      await _storage.saveAuthUser(demo, password);
      return demo;
    }
    return null;
  }

  Future<void> logout() => _storage.logout();

  Future<void> forgotPassword(String email) async {
    // TODO: Replace mock success with Supabase Auth reset email.
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }
}
