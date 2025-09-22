import 'package:bloc/bloc.dart';
import '../../../../core/services/secure_storage.dart';
import 'auth_state.dart';

import 'package:quickrider/core/errors/failures.dart';

import '../../domain/usecases/sent_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

import '../../domain/entities/user_entites.dart';

import 'package:quickrider/features/profile/data/datasources/profile_local_data_source.dart'; // <<< 1. IMPORT THIS

import 'package:quickrider/services/logger_services.dart'; // <<< Import logger

class AuthCubit extends Cubit<AuthState> {
  final SendOtp _sendOtpUseCase;
  final VerifyOtp _verifyOtpUseCase;
  final SecureStorage _secureStorage;
  final ProfileLocalDataSource _localDataSource;
  final AppLogger _logger; // <<< Add logger

  AuthCubit({
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
    required SecureStorage secureStorage,
    required ProfileLocalDataSource localDataSource,
    required AppLogger logger, // <<< Add to constructor
  }) : _sendOtpUseCase = sendOtp,
       _verifyOtpUseCase = verifyOtp,
       _secureStorage = secureStorage,
       _localDataSource = localDataSource,
       _logger = logger, // <<< Initialize logger
       super(AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    _logger.i('AuthCubit: Sending OTP to $phoneNumber');
    emit(const AuthLoading(isSendingOtp: true));
    final result = await _sendOtpUseCase(phoneNumber: phoneNumber);
    result.fold(
      (failure) {
        if (failure is ServerFailure &&
            failure.code == 429 &&
            failure.remainingSeconds != null) {
          _logger.w(
            'AuthCubit: OTP cooldown for $phoneNumber. Remaining: ${failure.remainingSeconds}s',
          );
          emit(
            AuthError(
              'OTP cooldown: Please try again in ${failure.remainingSeconds} seconds.',
            ),
          );
        } else {
          _logger.e(
            'AuthCubit: Failed to send OTP to $phoneNumber - ${failure.message}',
          );
          emit(AuthError(failure.message));
        }
      },
      (data) {
        final (verificationId, resendToken) = data;
        _logger.i(
          'AuthCubit: OTP sent successfully for $phoneNumber. Verification ID: $verificationId',
        );
        emit(
          AuthCodeSentSuccess(
            verificationId: verificationId,
            resendToken: resendToken,
          ),
        );
      },
    );
  }

  Future<void> verifyOtp(String verificationId, String otp) async {
    _logger.i('AuthCubit: Verifying OTP for verificationId: $verificationId');
    emit(const AuthLoading(isSendingOtp: false));
    final result = await _verifyOtpUseCase(
      otp: otp,
      verificationId: verificationId,
    );
    result.fold(
      (failure) {
        _logger.e('AuthCubit: Failed to verify OTP - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        final UserEntity userEntity = user;
        _logger.i(
          'AuthCubit: OTP verified successfully for user ID: ${userEntity.id}',
        );
        _handleSuccessfulLogin(userEntity);
      },
    );
  }

  Future<void> _handleSuccessfulLogin(UserEntity user) async {
    _logger.i('AuthCubit: Handling successful login for user ID: ${user.id}');
    // Save mock tokens
    await _secureStorage.saveTokens(
      access: 'mock_access_token_for_${user.id}',
      refresh: 'mock_refresh_token_for_${user.id}',
    );
    _logger.i('AuthCubit: Tokens saved for user ID: ${user.id}');

    // SAVE THE USER ID TO LOCAL STORAGE
    await _localDataSource.cacheUserId(user.id);
    // Log messages are now inside cacheUserId for better traceability

    emit(AuthLoggedInSuccess(user));
    _logger.i('AuthCubit: AuthLoggedInSuccess emitted for user ID: ${user.id}');
  }
}
