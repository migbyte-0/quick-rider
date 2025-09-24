import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

import '../../../auth/domain/entities/user_entites.dart';
import '../repository/profile_repository.dart';

import '../../../../core/usecase/usecase_params.dart';

class GetProfileUseCase implements UseCase<UserEntity, String> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await repository.getCurrentUserProfile(userId);
  }
}
