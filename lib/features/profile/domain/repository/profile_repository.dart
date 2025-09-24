import '../../../auth/domain/entities/user_entites.dart';

import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getCurrentUserProfile(String userId);
  Future<Either<Failure, Unit>> saveUserProfile(UserEntity user);
}
