import 'package:flutter/material.dart';
import '../../constants/constant_exports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double strokeWidth;

  const OutlineGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(strokeWidth),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r - strokeWidth),
            ),
            fixedSize: Size(double.infinity, 50.h - (strokeWidth * 2)),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: AppTextStyles.textStyle18().copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
