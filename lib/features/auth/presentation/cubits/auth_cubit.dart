import 'package:bloc/bloc.dart';
import '../../../../core/services/secure_storage.dart';
import 'auth_state.dart';

import 'package:quickrider/core/errors/failures.dart';

import '../../domain/usecases/sent_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

import '../../domain/entities/user_entites.dart';

class AuthCubit extends Cubit<AuthState> {
  final SendOtp _sendOtpUseCase;
  final VerifyOtp _verifyOtpUseCase;
  final SecureStorage _secureStorage;

  AuthCubit({
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
    required SecureStorage secureStorage,
  }) : _sendOtpUseCase = sendOtp,
       _verifyOtpUseCase = verifyOtp,
       _secureStorage = secureStorage,
       super(AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    emit(const AuthLoading(isSendingOtp: true));
    final result = await _sendOtpUseCase(phoneNumber: phoneNumber);
    result.fold(
      (failure) {
        if (failure is ServerFailure &&
            failure.code == 429 &&
            failure.remainingSeconds != null) {
          emit(
            AuthError(
              'OTP cooldown: Please try again in ${failure.remainingSeconds} seconds.',
            ),
          );
        } else {
          emit(AuthError(failure.message));
        }
      },
      (data) {
        final (verificationId, resendToken) = data;
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
    emit(const AuthLoading(isSendingOtp: false));
    final result = await _verifyOtpUseCase(
      otp: otp,
      verificationId: verificationId,
    );

    result.fold((failure) => emit(AuthError(failure.message)), (userAsObject) {
      final UserEntity user = userAsObject;
      _handleSuccessfulLogin(user);
    });
  }

  Future<void> _handleSuccessfulLogin(UserEntity user) async {
    await _secureStorage.saveTokens(
      access: 'mock_access_token_for_${user.id}',
      refresh: 'mock_refresh_token_for_${user.id}',
    );
    emit(AuthLoggedInSuccess(user));
  }
}
