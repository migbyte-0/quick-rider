import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.onBoardingThreeBackground,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
