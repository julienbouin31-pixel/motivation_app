import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';

abstract class OnboardingLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveProfile(UserProfileModel profile);
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
    } catch (e) {
      debugPrint('[OnboardingLocalDataSource] Erreur de parsing du profil: $e');
      return const UserProfileModel();
    }
  }

  @override
  Future<UserProfileModel> getUserProfile() => _readProfile();

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    await storage.write(
      key: _profileKey,
      value: json.encode(profile.toJson()),
    );
  }
}
