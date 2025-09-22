import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:quickrider/features/profile/data/models/user_model.dart';

import '../../../auth/domain/entities/user_entites.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_datasources.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> saveUserProfile(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await remoteDataSource.saveProfile(userModel);
      await localDataSource.cacheUserId(user.id);
    } catch (e) {
      throw ServerFailure('Failed to save profile: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getCurrentUserProfile(String userId) async {
    try {
      final userModel = await remoteDataSource.getProfile(userId);
      return userModel;
    } catch (e) {
      throw ServerFailure('Failed to fetch profile: ${e.toString()}');
    }
  }
}
