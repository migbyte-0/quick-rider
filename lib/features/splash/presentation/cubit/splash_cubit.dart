import 'package:bloc/bloc.dart';

import '../../../../core/services/secure_storage.dart';
import '../../../../services/onboarding_services.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final OnboardingService _onboardingService;
  final SecureStorage _secureStorage;

  SplashCubit({
    required OnboardingService onboardingService,
    required SecureStorage secureStorage,
  }) : _onboardingService = onboardingService,
       _secureStorage = secureStorage,
       super(SplashInitial());

  Future<void> decideNextRoute() async {
    await Future.delayed(const Duration(seconds: 3));

    final bool hasOnboarded = _onboardingService.hasCompletedOnboarding();
    final bool isLoggedIn = await _secureStorage.getTokens() != null;

    if (!hasOnboarded) {
      emit(const SplashNavigate('/onboarding'));
    } else if (!isLoggedIn) {
      emit(const SplashNavigate('/login'));
    } else {
      emit(const SplashNavigate('/home'));
    }
  }
}
