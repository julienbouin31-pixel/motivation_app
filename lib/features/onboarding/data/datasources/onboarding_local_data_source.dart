import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/storage/secure_storage.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';

abstract class OnboardingLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveProfile(UserProfileModel profile);
}

@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SecureStorage _secureStorage;

  OnboardingLocalDataSourceImpl({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<UserProfileModel> getUserProfile() async {
    final raw = await _secureStorage.readProfile();
    if (raw == null) return const UserProfileModel();
    try {
      return UserProfileModel.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[OnboardingLocalDataSource] Erreur de parsing du profil: $e');
      return const UserProfileModel();
    }
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    await _secureStorage.saveProfile(json.encode(profile.toJson()));
  }
}
