import 'package:get_it/get_it.dart';
import 'package:motivation_app/core/network/network_info.dart';
import 'package:motivation_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:motivation_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:motivation_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:motivation_app/features/home/domain/repositories/home_repository.dart';
import 'package:motivation_app/features/home/domain/usecases/get_home_data.dart';
import 'package:motivation_app/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ======================== Features - Home ========================

  // Bloc
  sl.registerFactory(() => HomeBloc(getHomeData: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetHomeData(sl()));

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
}
