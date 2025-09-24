import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:quickrider/features/profile/data/models/user_model.dart';

import '../../../auth/domain/entities/user_entites.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_datasources.dart';

import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/exceptions.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Unit>> saveUserProfile(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await remoteDataSource.saveProfile(userModel);
      await localDataSource.cacheUserId(user.id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserProfile(
      String userId) async {
    try {
      final userModel = await remoteDataSource.getProfile(userId);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
