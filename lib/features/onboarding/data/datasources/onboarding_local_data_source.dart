import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';

abstract class OnboardingLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveUserName(String name);
  Future<void> saveObjectiveType(String objectiveType);
  Future<void> saveStripeApiKey(String key);
  Future<void> saveMrrTarget(String target);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final FlutterSecureStorage storage;

  OnboardingLocalDataSourceImpl({required this.storage});

  static const _nameKey = 'onboarding_user_name';
  static const _objectiveKey = 'onboarding_objective_type';
  static const _stripeKey = 'onboarding_stripe_key';
  static const _mrrTargetKey = 'onboarding_mrr_target';

  @override
  Future<UserProfileModel> getUserProfile() async {
    final name = await storage.read(key: _nameKey);
    final objectiveType = await storage.read(key: _objectiveKey);
    final stripeApiKey = await storage.read(key: _stripeKey);
    final mrrTarget = await storage.read(key: _mrrTargetKey);
    return UserProfileModel(
      name: name ?? '',
      objectiveType: objectiveType,
      stripeApiKey: stripeApiKey,
      mrrTarget: mrrTarget,
    );
  }

  @override
  Future<void> saveUserName(String name) async {
    await storage.write(key: _nameKey, value: name);
  }

  @override
  Future<void> saveObjectiveType(String objectiveType) async {
    await storage.write(key: _objectiveKey, value: objectiveType);
  }

  @override
  Future<void> saveStripeApiKey(String key) async {
    await storage.write(key: _stripeKey, value: key);
  }

  @override
  Future<void> saveMrrTarget(String target) async {
    await storage.write(key: _mrrTargetKey, value: target);
  }
}
