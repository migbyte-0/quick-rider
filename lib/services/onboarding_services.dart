import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _kOnboardingCompleteKey = 'onboarding_complete';
  final SharedPreferences _prefs;

  OnboardingService(this._prefs);

  static Future<OnboardingService> newInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return OnboardingService(prefs);
  }

  bool hasCompletedOnboarding() {
    return _prefs.getBool(_kOnboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_kOnboardingCompleteKey, true);
  }
}
