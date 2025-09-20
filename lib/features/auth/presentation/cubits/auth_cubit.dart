import 'package:bloc/bloc.dart';
import '../../../../core/services/secure_storage.dart';
import '../../domain/usecases/sent_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  final SecureStorage _secureStorage;

  AuthCubit({
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
    required SecureStorage secureStorage,
  }) : _sendOtp = sendOtp,
       _verifyOtp = verifyOtp,
       _secureStorage = secureStorage,
       super(AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    emit(AuthLoading());
    final result = await _sendOtp(phoneNumber: phoneNumber);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthCodeSentSuccess()),
    );
  }

  Future<void> verifyOtp(String otp) async {
    emit(AuthLoading());
    final result = await _verifyOtp(otp: otp);
    result.fold((failure) => emit(AuthError(failure.message)), (user) async {
      await _secureStorage.saveTokens(
        access: 'mock_access_token_for_${user.id}',
        refresh: 'mock_refresh_token_for_${user.id}',
      );

      emit(AuthLoggedInSuccess(user));
    });
  }
}
