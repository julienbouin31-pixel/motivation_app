// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:motivation_app/core/database/app_database.dart' as _i55;
import 'package:motivation_app/core/di/injection_module.dart' as _i82;
import 'package:motivation_app/core/network/network_info.dart' as _i867;
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_local_data_source.dart'
    as _i987;
import 'package:motivation_app/features/affirmation/data/datasources/affirmation_remote_data_source.dart'
    as _i631;
import 'package:motivation_app/features/affirmation/data/repositories/affirmation_repository_impl.dart'
    as _i551;
import 'package:motivation_app/features/affirmation/domain/repositories/affirmation_repository.dart'
    as _i555;
import 'package:motivation_app/features/affirmation/domain/usecases/get_favorites_usecase.dart'
    as _i541;
import 'package:motivation_app/features/affirmation/domain/usecases/get_next_affirmation_usecase.dart'
    as _i269;
import 'package:motivation_app/features/affirmation/domain/usecases/mark_as_viewed_usecase.dart'
    as _i661;
import 'package:motivation_app/features/affirmation/domain/usecases/toggle_favorite_usecase.dart'
    as _i144;
import 'package:motivation_app/features/affirmation/presentation/bloc/affirmation_cubit.dart'
    as _i1059;
import 'package:motivation_app/features/affirmation/presentation/bloc/favorites_cubit.dart'
    as _i841;
import 'package:motivation_app/features/home/data/datasources/home_local_data_source.dart'
    as _i224;
import 'package:motivation_app/features/home/data/datasources/home_remote_data_source.dart'
    as _i924;
import 'package:motivation_app/features/home/data/repositories/home_repository_impl.dart'
    as _i1067;
import 'package:motivation_app/features/home/domain/repositories/home_repository.dart'
    as _i96;
import 'package:motivation_app/features/home/domain/usecases/get_home_data.dart'
    as _i500;
import 'package:motivation_app/features/home/presentation/bloc/home_cubit.dart'
    as _i1002;
import 'package:motivation_app/features/onboarding/data/datasources/onboarding_local_data_source.dart'
    as _i576;
import 'package:motivation_app/features/onboarding/data/models/user_profile_model.dart'
    as _i677;
import 'package:motivation_app/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i10;
import 'package:motivation_app/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i829;
import 'package:motivation_app/features/onboarding/domain/usecases/get_user_profile.dart'
    as _i178;
import 'package:motivation_app/features/onboarding/domain/usecases/save_mrr_target.dart'
    as _i744;
import 'package:motivation_app/features/onboarding/domain/usecases/save_objective_type.dart'
    as _i599;
import 'package:motivation_app/features/onboarding/domain/usecases/save_stripe_api_key.dart'
    as _i349;
import 'package:motivation_app/features/onboarding/domain/usecases/save_user_name.dart'
    as _i931;
import 'package:motivation_app/features/onboarding/presentation/bloc/onboarding_cubit.dart'
    as _i870;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.singleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.singleton<_i895.Connectivity>(() => appModule.connectivity);
    await gh.singletonAsync<_i55.AppDatabase>(
      () => appModule.appDatabase,
      preResolve: true,
    );
    gh.lazySingleton<_i224.HomeLocalDataSource>(
      () => _i224.HomeLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i867.NetworkInfo>(
      () => _i867.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i924.HomeRemoteDataSource>(
      () => _i924.HomeRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i631.AffirmationRemoteDataSource>(
      () => _i631.AffirmationRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i576.OnboardingLocalDataSource>(
      () => _i576.OnboardingLocalDataSourceImpl(
        storage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i829.OnboardingRepository>(
      () => _i10.OnboardingRepositoryImpl(
        localDataSource: gh<_i576.OnboardingLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i987.AffirmationLocalDataSource>(
      () => _i987.AffirmationLocalDataSourceImpl(db: gh<_i55.AppDatabase>()),
    );
    await gh.singletonAsync<_i677.UserProfileModel>(
      () => appModule.userProfile(gh<_i576.OnboardingLocalDataSource>()),
      preResolve: true,
    );
    gh.lazySingleton<_i96.HomeRepository>(
      () => _i1067.HomeRepositoryImpl(
        remoteDataSource: gh<_i924.HomeRemoteDataSource>(),
        localDataSource: gh<_i224.HomeLocalDataSource>(),
        networkInfo: gh<_i867.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i178.GetUserProfileUseCase>(
      () => _i178.GetUserProfileUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i744.SaveMrrTargetUseCase>(
      () => _i744.SaveMrrTargetUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i599.SaveObjectiveTypeUseCase>(
      () => _i599.SaveObjectiveTypeUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i349.SaveStripeApiKeyUseCase>(
      () => _i349.SaveStripeApiKeyUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i931.SaveUserNameUseCase>(
      () => _i931.SaveUserNameUseCase(gh<_i829.OnboardingRepository>()),
    );
    gh.lazySingleton<_i555.AffirmationRepository>(
      () => _i551.AffirmationRepositoryImpl(
        localDataSource: gh<_i987.AffirmationLocalDataSource>(),
        remoteDataSource: gh<_i631.AffirmationRemoteDataSource>(),
        networkInfo: gh<_i867.NetworkInfo>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
        userProfile: gh<_i677.UserProfileModel>(),
      ),
    );
    gh.factory<_i870.OnboardingCubit>(
      () => _i870.OnboardingCubit(
        getUserProfile: gh<_i178.GetUserProfileUseCase>(),
        saveUserName: gh<_i931.SaveUserNameUseCase>(),
        saveObjectiveType: gh<_i599.SaveObjectiveTypeUseCase>(),
        saveStripeApiKey: gh<_i349.SaveStripeApiKeyUseCase>(),
        saveMrrTarget: gh<_i744.SaveMrrTargetUseCase>(),
      ),
    );
    gh.lazySingleton<_i541.GetFavoritesUseCase>(
      () => _i541.GetFavoritesUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i269.GetNextAffirmationUseCase>(
      () => _i269.GetNextAffirmationUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i661.MarkAsViewedUseCase>(
      () => _i661.MarkAsViewedUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i144.ToggleFavoriteUseCase>(
      () => _i144.ToggleFavoriteUseCase(gh<_i555.AffirmationRepository>()),
    );
    gh.lazySingleton<_i500.GetHomeDataUseCase>(
      () => _i500.GetHomeDataUseCase(gh<_i96.HomeRepository>()),
    );
    gh.factory<_i841.FavoritesCubit>(
      () => _i841.FavoritesCubit(
        getFavorites: gh<_i541.GetFavoritesUseCase>(),
        toggleFavorite: gh<_i144.ToggleFavoriteUseCase>(),
      ),
    );
    gh.factory<_i1002.HomeCubit>(
      () => _i1002.HomeCubit(getHomeData: gh<_i500.GetHomeDataUseCase>()),
    );
    gh.factory<_i1059.AffirmationCubit>(
      () => _i1059.AffirmationCubit(
        getNextAffirmation: gh<_i269.GetNextAffirmationUseCase>(),
        markAsViewed: gh<_i661.MarkAsViewedUseCase>(),
        toggleFavorite: gh<_i144.ToggleFavoriteUseCase>(),
        storage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i82.AppModule {}
