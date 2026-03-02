import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

@singleton
class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // ─── Clés ────────────────────────────────────────────────────────────────
  static const String _keyProfile = 'onboarding_profile';
  static const String _keySelectedCategories = 'affirmation_selected_categories';
  static const String _keyLastFetchDate = 'affirmation_last_fetch_date';
  static const String _keyOnboardingDone = 'onboarding_done';
  static const String _markerFileName = '.onboarding_complete';
  // Profil stocké en fichier (Keychain iOS Simulator perd les données au restart)
  static const String _profileFileName = 'user_profile.json';

  // ─── Cache mémoire ────────────────────────────────────────────────────────
  bool _cachedOnboardingDone = false;
  bool get cachedOnboardingDone => _cachedOnboardingDone;

  Future<File> _markerFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _markerFileName));
  }

  Future<File> _profileFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _profileFileName));
  }

  // Appelé une seule fois dans main.dart avant runApp()
  // Vérifie d'abord le fichier marker (fiable sur simulateur iOS),
  // puis le Keychain comme fallback.
  Future<void> preloadCache() async {
    final marker = await _markerFile();
    if (await marker.exists()) {
      _cachedOnboardingDone = true;
      return;
    }
    _cachedOnboardingDone = await _storage.read(key: _keyOnboardingDone) == 'true';
  }

  // ─── Profil onboarding ───────────────────────────────────────────────────
  // Lit depuis le fichier (fiable) en priorité, fallback sur Keychain.
  Future<String?> readProfile() async {
    final file = await _profileFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) return content;
    }
    return _storage.read(key: _keyProfile);
  }

  // Sauvegarde dans le fichier ET le Keychain (double sécurité).
  Future<void> saveProfile(String jsonValue) async {
    final file = await _profileFile();
    await file.writeAsString(jsonValue);
    await _storage.write(key: _keyProfile, value: jsonValue);
  }

  // ─── Onboarding done ─────────────────────────────────────────────────────
  Future<void> setOnboardingDone() async {
    _cachedOnboardingDone = true;
    final marker = await _markerFile();
    await marker.create(recursive: true);
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
    final marker = await _markerFile();
    if (await marker.exists()) await marker.delete();
    final profileFile = await _profileFile();
    if (await profileFile.exists()) await profileFile.delete();
    await _storage.deleteAll();
  }
}
