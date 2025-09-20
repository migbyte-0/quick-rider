import 'package:flutter/material.dart';

import '../../../core/constants/constant_exports.dart';

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
