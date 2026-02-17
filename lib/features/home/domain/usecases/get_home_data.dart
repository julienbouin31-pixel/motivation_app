import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/core/usecases/usecase.dart';
import 'package:motivation_app/features/home/domain/entities/home_entity.dart';
import 'package:motivation_app/features/home/domain/repositories/home_repository.dart';

class GetHomeData extends UseCase<List<HomeEntity>, NoParams> {
  final HomeRepository repository;

  GetHomeData(this.repository);

  @override
  Future<Either<Failure, List<HomeEntity>>> call(NoParams params) {
    return repository.getHomeData();
  }
}
