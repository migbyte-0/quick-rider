import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

abstract class NoParamUseCase<T> {
  Future<Either<Failure, T>> call();
}
