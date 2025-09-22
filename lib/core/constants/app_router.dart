import 'package:flutter/material.dart';
import 'package:quickrider/features/profile/presentation/screens/profile_screen.dart';
import 'package:quickrider/features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/auth_screens.dart';
import '../../features/onboarding/presentation/sceens/onboarding_screen.dart';
import '../shared/widgets/custom_navbar.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const NavBar());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
