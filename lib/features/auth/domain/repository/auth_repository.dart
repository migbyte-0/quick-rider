import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entites.dart';

abstract class AuthRepository {
  Future<Either<Failure, (String verificationId, int? resendToken)>> sendOtp({
    required String phoneNumber,
  });

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String verificationId,
    required String otp,
  });
}
