import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // ─── Clés ────────────────────────────────────────────────────────────────
  static const String _keyProfile = 'onboarding_profile';
  static const String _keySelectedCategories = 'affirmation_selected_categories';
  static const String _keyLastFetchDate = 'affirmation_last_fetch_date';
  static const String _keyOnboardingDone = 'onboarding_done';

  // ─── Cache mémoire ────────────────────────────────────────────────────────
  bool _cachedOnboardingDone = false;
  bool get cachedOnboardingDone => _cachedOnboardingDone;

  // Appelé une seule fois dans main.dart avant runApp()
  Future<void> preloadCache() async {
    _cachedOnboardingDone = await _storage.read(key: _keyOnboardingDone) == 'true';
  }

  // ─── Profil onboarding ───────────────────────────────────────────────────
  Future<String?> readProfile() async {
    return _storage.read(key: _keyProfile);
  }

  Future<void> saveProfile(String jsonValue) async {
    await _storage.write(key: _keyProfile, value: jsonValue);
  }

  // ─── Onboarding done ─────────────────────────────────────────────────────
  Future<void> setOnboardingDone() async {
    _cachedOnboardingDone = true;
    await _storage.write(key: _keyOnboardingDone, value: 'true');
  }

  // ─── Catégories affirmation ──────────────────────────────────────────────
  Future<String?> readCategories() async {
    return _storage.read(key: _keySelectedCategories);
  }

  Future<void> saveCategories(String value) async {
    await _storage.write(key: _keySelectedCategories, value: value);
  }

  // ─── Date du dernier fetch ───────────────────────────────────────────────
  Future<String?> readLastFetchDate() async {
    return _storage.read(key: _keyLastFetchDate);
  }

  Future<void> saveLastFetchDate(String value) async {
    await _storage.write(key: _keyLastFetchDate, value: value);
  }

  // ─── Reset complet ────────────────────────────────────────────────────────
  Future<void> deleteAll() async {
    _cachedOnboardingDone = false;
    await _storage.deleteAll();
  }
}
