import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/constant_exports.dart';
import 'onboarding_model.dart';

class ScreenIndicator extends StatelessWidget {
  const ScreenIndicator({
    super.key,
    required List<OnboardingContent> contents,
    required int currentPage,
  }) : _contents = contents,
       _currentPage = currentPage;

  final List<OnboardingContent> _contents;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _contents.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _currentPage == index ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
