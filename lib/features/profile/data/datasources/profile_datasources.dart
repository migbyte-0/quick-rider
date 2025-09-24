import '../../../auth/domain/entities/user_entites.dart';

abstract class ProfileRemoteDataSource {
  Future<UserEntity> saveProfile(UserEntity user);
  Future<UserEntity> getProfile(String userId);
}
