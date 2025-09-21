import '../../../../core/errors/exceptions.dart';
import '../../../../services/logger_services.dart';
import '../../domain/entities/user_entites.dart';

abstract class AuthRemoteDataSource {
  Future<(String verificationId, int? resendToken)> sendOtp({
    required String phoneNumber,
  });
  Future<UserEntity> verifyOtp({
    required String verificationId,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppLogger logger;
  String? _mockLastVerificationId;
  String _mockLastPhoneNumber = '';
  DateTime? _lastOtpSentTime;
  static const int _otpCooldownSeconds = 30;

  AuthRemoteDataSourceImpl({required this.logger});

  @override
  Future<(String verificationId, int? resendToken)> sendOtp({
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_lastOtpSentTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastOtpSentTime!);
      if (difference.inSeconds < _otpCooldownSeconds) {
        final remaining = _otpCooldownSeconds - difference.inSeconds;
        throw ServerException(
          'Too many OTP requests. Please try again after $remaining seconds.',
          code: 429,
          remainingSeconds: remaining,
        );
      }
    }

    if (RegExp(r'^(?:[0-9]{9}|[0-9]{10})$').hasMatch(phoneNumber)) {
      _mockLastPhoneNumber = phoneNumber;
      _mockLastVerificationId =
          'mock_verification_id_${DateTime.now().millisecondsSinceEpoch}';
      final int mockResendToken = DateTime.now().second;
      _lastOtpSentTime = DateTime.now();
      logger.i(
        'Mock OTP sent to $phoneNumber. The code is 123456. Verification ID: $_mockLastVerificationId',
      );
      return (_mockLastVerificationId!, mockResendToken);
    } else {
      throw ServerException('Invalid phone number format.', code: 400);
    }
  }

  @override
  Future<UserEntity> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (otp == '123456' &&
        verificationId == _mockLastVerificationId &&
        _mockLastPhoneNumber.isNotEmpty) {
      logger.i('Mock OTP verified successfully for $_mockLastPhoneNumber.');

      _mockLastVerificationId = null;
      _lastOtpSentTime = null;
      return UserEntity(
        id: 'mock_user_id_from_verified_otp',
        name: 'Al-Kharj Rider',
        phoneNumber: _mockLastPhoneNumber,
      );
    } else {
      throw ServerException(
        'Invalid OTP code or verification ID mismatch.',
        code: 401,
      );
    }
  }
}
