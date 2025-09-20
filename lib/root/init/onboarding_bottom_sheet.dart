import 'package:discounta/init/start/screen_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/constant_exports.dart';
import '../../core/shared/widgets/elevated_button.dart';
import 'onboarding_model.dart';

class OnboardingBottomSheet extends StatelessWidget {
  const OnboardingBottomSheet({
    super.key,
    required List<OnboardingContent> contents,
    required int currentPage,
    required PageController pageController,
    required this.onFinish,
  }) : _contents = contents,
       _currentPage = currentPage,
       _pageController = pageController;

  final List<OnboardingContent> _contents;
  final int _currentPage;
  final PageController _pageController;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _contents.length - 1;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _contents[_currentPage].title,
              style: AppTextStyles.dialogTitle.copyWith(fontSize: 22.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _contents[_currentPage].description,
              style: AppTextStyles.descriptionText.copyWith(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ScreenIndicator(contents: _contents, currentPage: _currentPage),
            SizedBox(height: 20.h),
            GradientButton(
              text: isLastPage ? AppStrings.start : AppStrings.next,
              onPressed: () {
                if (!isLastPage) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  onFinish();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
