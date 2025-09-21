import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.onBoardingTwoBackground,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
