import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entites.dart';
import '../repository/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<Either<Failure, User>> call({required String otp}) async {
    return await repository.verifyOtp(otp: otp);
  }
}
