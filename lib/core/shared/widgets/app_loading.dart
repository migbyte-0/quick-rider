import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickrider/core/constants/constant_exports.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        AppAssets.loading,
        width: 150,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }
}
