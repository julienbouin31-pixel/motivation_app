import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart';

@module
abstract class AppModule {
  @singleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @singleton
  Connectivity get connectivity => Connectivity();

  @preResolve
  @singleton
  Future<AppDatabase> get appDatabase => openAppDatabase();

  /// Charge le profil utilisateur depuis le stockage JSON au démarrage.
  /// Disponible dans tout le graphe de dépendances comme singleton.
  @preResolve
  @singleton
  Future<UserProfileModel> userProfile(OnboardingLocalDataSource dataSource) =>
      dataSource.getUserProfile();
}
