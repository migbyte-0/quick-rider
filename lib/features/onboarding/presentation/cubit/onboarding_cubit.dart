import 'package:bloc/bloc.dart';

import '../../../../services/onboarding_services.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingService _onboardingService;

  OnboardingCubit({required OnboardingService onboardingService})
    : _onboardingService = onboardingService,
      super(OnboardingInitial());

  Future<void> finishOnboarding() async {
    await _onboardingService.setOnboardingCompleted();
    emit(OnboardingComplete());
  }
}
