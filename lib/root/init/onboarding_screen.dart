import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quickrider/root/init/onboarding_model.dart';
import '../../core/constants/constant_exports.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/app_localizations.dart';
import 'onboarding_bottom_sheet.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: l10n.onBoardingTitleOne,
      description: AppStrings.onBoardingDescriptionOne,
      image: AppAssets.onBoardingOneBackground,
    ),
    OnboardingContent(
      title: AppStrings.onBoardingTitleTwo,
      description: AppStrings.onBoardingDescriptionTwo,
      image: AppAssets.onBoardingTwoBackground,
    ),
    OnboardingContent(
      title: AppStrings.onBoardingTitleThree,
      description: AppStrings.onBoardingDescriptionThree,
      image: AppAssets.onBoardingThreeBackground,
    ),
  ];

  void _finishOnboarding() {
    context.read<OnboardingCubit>().finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: _contents.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _contents[index].image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: OnboardingBottomSheet(
                contents: _contents,
                currentPage: _currentPage,
                pageController: _pageController,
                onFinish: _finishOnboarding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
