import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.sl.isReady<OnboardingService>();

  final onboardingService = di.sl<OnboardingService>();
  final secureStorage = di.sl<SecureStorage>();

  String initialRoute = '/'; // Default to SplashScreen for logged-in users

  final bool hasOnboarded = onboardingService.hasCompletedOnboarding();
  final bool isLoggedIn = await secureStorage.getTokens() != null;

  if (!hasOnboarded) {
    initialRoute = '/onboarding';
  } else if (!isLoggedIn) {
    initialRoute = '/login';
  }

  runApp(QuickRider(initialRoute: initialRoute));
}
