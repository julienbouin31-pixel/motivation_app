import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/exceptions.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/core/network/network_info.dart';
import 'package:motivation_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:motivation_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:motivation_app/features/home/domain/entities/home_entity.dart';
import 'package:motivation_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HomeEntity>>> getHomeData() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getHomeData();
        await localDataSource.cacheHomeData(remoteData);
        return Right(remoteData);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localData = await localDataSource.getLastHomeData();
        return Right(localData);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
