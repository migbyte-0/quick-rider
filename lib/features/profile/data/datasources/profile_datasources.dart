import '../../../auth/domain/entities/user_entites.dart';

abstract class ProfileRemoteDataSource {
  Future<UserEntity> saveProfile(UserEntity user);
  Future<UserEntity> getProfile(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Map<String, UserEntity> _mockProfiles = {};

  // This constructor (or an injected DioClient)
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
