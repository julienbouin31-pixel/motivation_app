// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:motivation_app/core/analytics/activity_logger.dart' as _i122;
import 'package:motivation_app/core/database/app_database.dart' as _i55;
import 'package:motivation_app/core/di/injection_module.dart' as _i82;
import 'package:motivation_app/core/network/dio_module.dart' as _i526;
import 'package:motivation_app/core/network/network_info.dart' as _i867;
import 'package:motivation_app/core/storage/secure_storage.dart' as _i35;
import 'package:motivation_app/core/streak/streak_cubit.dart' as _i179;
import 'package:motivation_app/core/streak/streak_remote_data_source.dart'
    as _i61;
import 'package:motivation_app/core/sync/handlers/activity_sync_handler.dart'
    as _i512;
import 'package:motivation_app/core/sync/handlers/custom_affirmation_sync_handler.dart'
    as _i599;
import 'package:motivation_app/core/sync/handlers/favorite_sync_handler.dart'
    as _i706;
import 'package:motivation_app/core/sync/handlers/profile_sync_handler.dart'
    as _i1036;
import 'package:motivation_app/core/sync/handlers/streak_sync_handler.dart'
    as _i92;
import 'package:motivation_app/core/sync/one_time_migration.dart' as _i102;
import 'package:motivation_app/core/sync/sync_queue_dao.dart' as _i15;
import 'package:motivation_app/core/sync/sync_service.dart' as _i437;
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart'
    as _i987;
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart'
    as _i631;
import 'package:motivation_app/features/affirmation/data/datasources/custom_affirmation_remote_data_source.dart'
    as _i843;
import 'package:motivation_app/features/affirmation/data/datasources/favorite_remote_data_source.dart'
    as _i871;
import 'package:motivation_app/features/affirmation/data/repositories/affirmation_repository_impl.dart'
    as _i551;
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart'
    as _i555;
import 'package:motivation_app/features/affirmation/domain/usecases/get_favorites_usecase.dart'
    as _i541;
import 'package:motivation_app/features/affirmation/domain/usecases/get_next_affirmation_usecase.dart'
    as _i269;
import 'package:motivation_app/features/affirmation/domain/usecases/get_saved_categories_usecase.dart'
    as _i756;
import 'package:motivation_app/features/affirmation/domain/usecases/mark_as_viewed_usecase.dart'
    as _i661;
import 'package:motivation_app/features/affirmation/domain/usecases/save_categories_usecase.dart'
    as _i192;
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart'
    as _i144;
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart'
    as _i1059;
import 'package:motivation_app/features/affirmation/presentation/bloc/custom_affirmations_cubit.dart'
    as _i555;
import 'package:motivation_app/features/affirmation/presentation/bloc/favorites_cubit.dart'
    as _i841;
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart'
    as _i576;
import 'package:motivation_app/features/onboarding/data/datasources/profile_remote_data_source.dart'
    as _i286;
import 'package:motivation_app/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i10;
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i829;
import 'package:motivation_app/features/onboarding/domain/usecases/get_user_profile.dart'
    as _i178;
import 'package:motivation_app/features/onboarding/domain/usecases/save_user_profile.dart'
    as _i140;
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i870;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    final dioModule = _$DioModule();
    gh.singleton<_i895.Connectivity>(() => appModule.connectivity);
    await gh.singletonAsync<_i55.AppDatabase>(
      () => appModule.appDatabase,
      preResolve: true,
    );
    gh.singleton<_i35.SecureStorage>(() => _i35.SecureStorage());
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabase);
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio);
    gh.lazySingleton<_i61.StreakRemoteDataSource>(
      () => _i61.StreakRemoteDataSource(),
    );
    gh.lazySingleton<_i512.ActivitySyncHandler>(
      () => _i512.ActivitySyncHandler(),
    );
    gh.lazySingleton<_i843.CustomAffirmationRemoteDataSource>(
      () => _i843.CustomAffirmationRemoteDataSource(),
    );
    gh.lazySingleton<_i871.FavoriteRemoteDataSource>(
      () => _i871.FavoriteRemoteDataSource(),
    );
    gh.lazySingleton<_i286.ProfileRemoteDataSource>(
      () => _i286.ProfileRemoteDataSource(),
    );
    gh.lazySingleton<_i1036.ProfileSyncHandler>(
      () => _i1036.ProfileSyncHandler(gh<_i286.ProfileRemoteDataSource>()),
    );
    gh.lazySingleton<_i92.StreakSyncHandler>(
      () => _i92.StreakSyncHandler(gh<_i61.StreakRemoteDataSource>()),
    );
    gh.lazySingleton<_i15.SyncQueueDao>(
      () => _i15.SyncQueueDao(gh<_i55.AppDatabase>()),
    );
    gh.lazySingleton<_i867.NetworkInfo>(
      () => _i867.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i631.AffirmationRemoteDataSource>(
      () => _i631.AffirmationRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i987.AffirmationLocalDataSource>(
      () => _i987.AffirmationLocalDataSourceImpl(
        db: gh<_i55.AppDatabase>(),
        secureStorage: gh<_i35.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i599.CustomAffirmationSyncHandler>(
      () => _i599.CustomAffirmationSyncHandler(
        gh<_i843.CustomAffirmationRemoteDataSource>(),
        gh<_i987.AffirmationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i576.OnboardingLocalDataSource>(
      () => _i576.OnboardingLocalDataSourceImpl(
        secureStorage: gh<_i35.SecureStorage>(),
      ),
    );
    gh.lazySingleton<_i706.FavoriteSyncHandler>(
      () => _i706.FavoriteSyncHandler(
        gh<_i871.FavoriteRemoteDataSource>(),
        gh<_i987.AffirmationLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i122.ActivityLogger>(
      () => _i122.ActivityLogger(gh<_i15.SyncQueueDao>()),
    );
    gh.lazySingleton<_i179.StreakCubit>(
      () =>
          _i179.StreakCubit(gh<_i35.SecureStorage>(), gh<_i15.SyncQueueDao>()),
    );
    gh.lazySingleton<_i829.OnboardingRepository>(
      () => _i10.OnboardingRepositoryImpl(
        localDataSource: gh<_i576.OnboardingLocalDataSource>(),
        syncQueue: gh<_i15.SyncQueueDao>(),
      ),
    );
    gh.lazySingleton<_i102.OneTimeMigration>(
      () => _i102.OneTimeMigration(
        gh<_i35.SecureStorage>(),
        gh<_i15.SyncQueueDao>(),
        gh<_i576.OnboardingLocalDataSource>(),
        gh<_i987.AffirmationLocalDataSource>(),
        gh<_i55.AppDatabase>(),
      ),
    );
    await gh.singletonAsync<_i437.SyncService>(
      () => appModule.syncService(
        gh<_i15.SyncQueueDao>(),
        gh<_i895.Connectivity>(),
        gh<_i1036.ProfileSyncHandler>(),
        gh<_i92.StreakSyncHandler>(),
        gh<_i599.CustomAffirmationSyncHandler>(),
        gh<_i706.FavoriteSyncHandler>(),
        gh<_i512.ActivitySyncHandler>(),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i178.GetUserProfileUseCase>(
      () => _i178.GetUserProfileUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i140.SaveUserProfileUseCase>(
      () => _i140.SaveUserProfileUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i870.OnboardingCubit>(
      () => _i870.OnboardingCubit(
        getUserProfile: gh<_i178.GetUserProfileUseCase>(),
        saveUserProfile: gh<_i140.SaveUserProfileUseCase>(),
      ),
    );
    gh.lazySingleton<_i555.AffirmationRepository>(
      () => _i551.AffirmationRepositoryImpl(
        localDataSource: gh<_i987.AffirmationLocalDataSource>(),
        remoteDataSource: gh<_i631.AffirmationRemoteDataSource>(),
        networkInfo: gh<_i867.NetworkInfo>(),
        getUserProfile: gh<_i178.GetUserProfileUseCase>(),
        syncQueue: gh<_i15.SyncQueueDao>(),
        activityLogger: gh<_i122.ActivityLogger>(),
      ),
    );
    gh.lazySingleton<_i541.GetFavoritesUseCase>(
      () => _i541.GetFavoritesUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i269.GetNextAffirmationUseCase>(
      () => _i269.GetNextAffirmationUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i756.GetSavedCategoriesUseCase>(
      () => _i756.GetSavedCategoriesUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i661.MarkAsViewedUseCase>(
      () => _i661.MarkAsViewedUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i192.SaveCategoriesUseCase>(
      () => _i192.SaveCategoriesUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i144.ToggleFavoriteUseCase>(
      () => _i144.ToggleFavoriteUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.factory<_i555.CustomAffirmationsCubit>(
      () => _i555.CustomAffirmationsCubit(gh<_i555.AffirmationRepository>()),
    );
    gh.factory<_i1059.AffirmationCubit>(
      () => _i1059.AffirmationCubit(
        getNextAffirmation: gh<_i269.GetNextAffirmationUseCase>(),
        markAsViewed: gh<_i661.MarkAsViewedUseCase>(),
        toggleFavorite: gh<_i144.ToggleFavoriteUseCase>(),
        getSavedCategories: gh<_i756.GetSavedCategoriesUseCase>(),
        saveCategories: gh<_i192.SaveCategoriesUseCase>(),
      ),
    );
    gh.factory<_i841.FavoritesCubit>(
      () => _i841.FavoritesCubit(
        getFavorites: gh<_i541.GetFavoritesUseCase>(),
        toggleFavorite: gh<_i144.ToggleFavoriteUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i82.AppModule {}

class _$DioModule extends _i526.DioModule {}
