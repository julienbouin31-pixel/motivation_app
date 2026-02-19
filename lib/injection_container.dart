import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:motivation_app/core/database/app_database.dart';
import 'package:motivation_app/core/network/network_info.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart';
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart';
import 'package:motivation_app/features/affirmation/data/repositories/affirmation_repository_impl.dart';
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_favorites_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/get_next_affirmation_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/mark_as_viewed_usecase.dart';
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart';
import 'package:motivation_app/features/affirmation/presentation/bloc/favorites_cubit.dart';
import 'package:motivation_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:motivation_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:motivation_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:motivation_app/features/home/domain/repositories/home_repository.dart';
import 'package:motivation_app/features/home/domain/usecases/get_home_data.dart';
import 'package:motivation_app/features/home/presentation/bloc/home_cubit.dart';
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:motivation_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/get_user_profile.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_mrr_target.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_objective_type.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_stripe_api_key.dart';
import 'package:motivation_app/features/onboarding/domain/usecases/save_user_name.dart';
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart';

final sl = GetIt.instance;

Future<void> init({
  required AppDatabase db,
  String objectiveType = 'mrr',
  String? mrrTarget,
  String? userName,
}) async {
  // ======================== Features - Affirmation ========================

  // Cubit
  sl.registerFactory(() => AffirmationCubit(
        getNextAffirmation: sl(),
        markAsViewed: sl(),
        toggleFavorite: sl(),
        storage: sl(),
      ));

  // Cubits
  sl.registerFactory(() => FavoritesCubit(
        getFavorites: sl(),
        toggleFavorite: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => GetNextAffirmationUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsViewedUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AffirmationRepository>(
    () => AffirmationRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
      secureStorage: sl(),
      objectiveType: objectiveType,
      mrrTarget: mrrTarget,
      userName: userName,
    ),
  );

  // Data sources
  sl.registerLazySingleton<AffirmationLocalDataSource>(
    () => AffirmationLocalDataSourceImpl(db: sl()),
  );
  sl.registerLazySingleton<AffirmationRemoteDataSource>(
    () => AffirmationRemoteDataSourceImpl(),
  );

  // Database
  sl.registerLazySingleton<AppDatabase>(() => db);

  // ======================== Features - Onboarding ========================

  // Cubit
  sl.registerFactory(() => OnboardingCubit(
        getUserProfile: sl(),
        saveUserName: sl(),
        saveObjectiveType: sl(),
        saveStripeApiKey: sl(),
        saveMrrTarget: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => SaveUserNameUseCase(sl()));
  sl.registerLazySingleton(() => SaveObjectiveTypeUseCase(sl()));
  sl.registerLazySingleton(() => SaveStripeApiKeyUseCase(sl()));
  sl.registerLazySingleton(() => SaveMrrTargetUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(storage: sl()),
  );

  // ======================== Features - Home ========================

  // Cubit
  sl.registerFactory(() => HomeCubit(getHomeData: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetHomeDataUseCase(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  // ======================== Core ========================

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
