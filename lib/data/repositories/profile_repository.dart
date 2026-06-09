import '../../domain/models/user_profile.dart';
import '../local/local_storage_service.dart';

class ProfileRepository {
  ProfileRepository(this._storage);

  final LocalStorageService _storage;

  Future<UserProfile?> getProfile() => _storage.getProfile();

  Future<void> saveProfile(UserProfile profile) =>
      _storage.saveProfile(profile);
}
