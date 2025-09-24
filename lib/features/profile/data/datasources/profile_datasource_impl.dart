import '../../../auth/domain/domain_exports.dart';
import '../data_exports.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Map<String, UserEntity> _mockProfiles = {};

  ProfileRemoteDataSourceImpl();

  @override
  Future<UserEntity> saveProfile(UserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _mockProfiles[user.id] = user;
    print('Simulating saving user profile for ID: ${user.id}');
    print('Name: ${user.name}, City: ${user.city}');
    return user;
  }

  @override
  Future<UserEntity> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // using the userId.

    if (_mockProfiles.containsKey(userId)) {
      print(
        'ProfileRemoteDataSource: Returning profile from mock store for ID: $userId',
      );
      return _mockProfiles[userId]!;
    }

    print(
      'ProfileRemoteDataSource: Returning default mock profile for ID: $userId',
    );
    return UserEntity(
      id: 'mock_user_id_from_remote',
      phoneNumber: '5551234567',
      name: 'Mock User',
      city: 'Mock City',
    );
  }
}
