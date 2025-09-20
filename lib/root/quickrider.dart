import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/l10n/app_localizations.dart';

import '../core/constants/constant_exports.dart';

class QuickRider extends StatelessWidget {
  final String initialRoute;

  const QuickRider({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QuickRider',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              scaffoldBackgroundColor: Colors.grey[100],
              fontFamily: 'Tajawal',
            ),
            initialRoute: initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
