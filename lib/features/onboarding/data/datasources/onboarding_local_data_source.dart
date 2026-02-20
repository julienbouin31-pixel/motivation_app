import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';

abstract class OnboardingLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveUserName(String name);
  Future<void> saveObjectiveType(String objectiveType);
  Future<void> saveStripeApiKey(String key);
  Future<void> saveMrrTarget(String target);
}

@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final FlutterSecureStorage storage;

  OnboardingLocalDataSourceImpl({required this.storage});

  static const _profileKey = 'onboarding_profile';

  Future<UserProfileModel> _readProfile() async {
    final raw = await storage.read(key: _profileKey);
    if (raw == null) return const UserProfileModel();
    try {
      return UserProfileModel.fromJson(
          json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserProfileModel();
    }
  }

  Future<void> _writeProfile(UserProfileModel profile) async {
    await storage.write(
      key: _profileKey,
      value: json.encode(profile.toJson()),
    );
  }

  @override
  Future<UserProfileModel> getUserProfile() => _readProfile();

  @override
  Future<void> saveUserName(String name) async {
    final profile = await _readProfile();
    await _writeProfile(profile.copyWith(name: name));
  }

  @override
  Future<void> saveObjectiveType(String objectiveType) async {
    final profile = await _readProfile();
    await _writeProfile(profile.copyWith(objectiveType: objectiveType));
  }

  @override
  Future<void> saveStripeApiKey(String key) async {
    final profile = await _readProfile();
    await _writeProfile(profile.copyWith(stripeApiKey: key));
  }

  @override
  Future<void> saveMrrTarget(String target) async {
    final profile = await _readProfile();
    await _writeProfile(profile.copyWith(mrrTarget: target));
  }
}
