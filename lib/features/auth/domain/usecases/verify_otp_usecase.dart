import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entites.dart';
import '../repository/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String verificationId,
    required String otp,
  }) async {
    return await repository.verifyOtp(verificationId: verificationId, otp: otp);
  }
}
