import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';
import 'package:motivation_app/features/home/domain/entities/home_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<HomeEntity>>> getHomeData();
}
