import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entites.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp({required String phoneNumber});
  Future<User> verifyOtp({required String otp});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  String? _lastPhoneNumber;

  @override
  Future<void> sendOtp({required String phoneNumber}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (RegExp(r'^05\d{8}$').hasMatch(phoneNumber)) {
      _lastPhoneNumber = phoneNumber;
      print('Mock OTP sent to $phoneNumber. The code is 123456');
      return;
    } else {
      throw ServerException('Invalid phone number format.');
    }
  }

  @override
  Future<User> verifyOtp({required String otp}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (otp == '123456' && _lastPhoneNumber != null) {
      return User(
        id: 'mock_user_123',
        name: 'Al-Kharj Rider',
        phoneNumber: _lastPhoneNumber!,
      );
    } else {
      throw ServerException('Invalid OTP code.');
    }
  }
}
