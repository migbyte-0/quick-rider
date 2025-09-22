import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../../../auth/domain/entities/user_entites.dart';
import '../repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity?>> call(String userId) async {
    try {
      final user = await repository.getCurrentUserProfile(userId);
      if (user != null) {
        return Right(user);
      } else {
        return Left(ServerFailure('User profile not found.'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
