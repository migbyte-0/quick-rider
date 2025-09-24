import 'package:flutter/material.dart';
import 'package:quickrider/features/legal/presentation/screens/faq_screen.dart';
import 'package:quickrider/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:quickrider/features/payment/presentation/presentation_exports.dart';
import 'package:quickrider/features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/auth_screens.dart';
import '../../features/onboarding/presentation/sceens/onboarding_screen.dart';
import '../shared/widgets/custom_navbar.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const NavBar());
      case '/faq':
        return MaterialPageRoute(builder: (_) => const FaqScreen());
      case '/policy':
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case '/addpayment':
        return MaterialPageRoute(builder: (_) => const AddPaymentScreen());
      case '/payment':
        return MaterialPageRoute(builder: (_) => const PaymentMethodsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
