import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../../../auth/domain/entities/user_entites.dart';
import '../repository/profile_repository.dart';

import '../../../../core/usecase/usecase_params.dart';

class SaveProfileUseCase implements UseCase<Unit, UserEntity> {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UserEntity user) async {
    return await repository.saveUserProfile(user);
  }
}
