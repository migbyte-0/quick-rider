import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entites.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp({required String phoneNumber});
  Future<Either<Failure, User>> verifyOtp({required String otp});
}
