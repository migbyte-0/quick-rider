import 'package:flutter/material.dart';

import '../../../core/constants/constant_exports.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.onBoardingOneBackground,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
