import '../../../auth/domain/entities/user_entites.dart';

abstract class ProfileRepository {
  Future<void> saveUserProfile(UserEntity user);
  Future<UserEntity?> getCurrentUserProfile(String userId);
}
