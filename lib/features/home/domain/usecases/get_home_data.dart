import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/home/domain/entities/home_entity.dart';
import 'package:motivation_app/features/home/domain/repositories/home_repository.dart';

@lazySingleton
class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<Either<Failure, List<HomeEntity>>> call() {
    return repository.getHomeData();
  }
}
