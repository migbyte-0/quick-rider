import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomGradientContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CustomGradientContainer({
    super.key,
    this.child,
    this.height,
    this.borderRadius = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.infinity,
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
