import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/core/shared/shared_exports.dart';

import '../../../../core/constants/app_assets.dart' show AppAssets;
import '../cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();

    context.read<SplashCubit>().decideNextRoute();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigate) {
          Navigator.pushReplacementNamed(context, state.routeName);
        }
      },
      child: Scaffold(
        body: GradientContainer(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SvgPicture.asset(AppAssets.logo),
            ),
          ),
        ),
      ),
    );
  }
}
