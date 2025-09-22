import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../../../auth/domain/entities/user_entites.dart';
import '../repository/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) async {
    try {
      await repository.saveUserProfile(user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
