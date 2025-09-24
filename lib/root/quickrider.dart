import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/di/di.dart';
import 'package:quickrider/core/language/cubit/language_cubit.dart';
import 'package:quickrider/features/payment/presentation/cubits/payment_cubit.dart';
import 'package:quickrider/features/profile/presentation/presentation_exports.dart';
import 'package:quickrider/l10n/app_localizations.dart';
import '../core/constants/constant_exports.dart';
import '../features/auth/presentation/cubits/auth_cubit.dart';
import '../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../features/splash/presentation/cubit/splash_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quickrider/core/language/cubit/language_state.dart';

class QuickRider extends StatelessWidget {
  final String initialRoute;

  const QuickRider({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<OnboardingCubit>(create: (_) => sl<OnboardingCubit>()),
        BlocProvider<SplashCubit>(create: (_) => sl<SplashCubit>()),
        BlocProvider<ProfileSetupCubit>(create: (_) => sl<ProfileSetupCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
        BlocProvider<LanguageCubit>(create: (_) => sl<LanguageCubit>()),
        BlocProvider<PaymentCubit>(create: (_) => sl<PaymentCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'QuickRider',
                locale: languageState.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                theme: ThemeData(
                  primarySwatch: AppColors.createMaterialColor(
                    AppColors.primary,
                  ),
                  scaffoldBackgroundColor: Colors.grey[100],
                  fontFamily: 'Tajawal',
                ),
                initialRoute: initialRoute,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
