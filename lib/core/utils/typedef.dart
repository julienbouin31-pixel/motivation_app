import 'package:dartz/dartz.dart';
import 'package:motivation_app/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
