import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entites.dart';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_datasources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, (String, int?)>> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      final (verificationId, resendToken) = await remoteDataSource.sendOtp(
        phoneNumber: phoneNumber,
      );
      return Right((verificationId, resendToken));
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          code: e.code,
          remainingSeconds: e.remainingSeconds,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // The direct call to remoteDataSource.verifyOtp returns a Future<UserEntity>.
      // The `user` here is correctly inferred as UserEntity.
      final UserEntity user = await remoteDataSource.verifyOtp(
        verificationId: verificationId,
        otp: otp,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.message,
          code: e.code,
          remainingSeconds: e.remainingSeconds,
        ),
      );
    }
  }
}
