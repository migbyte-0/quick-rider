import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/core/constants/constant_exports.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/model/onboarding_model.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_bottom_sheet.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _finishOnboarding() {
    context.read<OnboardingCubit>().finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<OnboardingContent> contents = [
      OnboardingContent(
        title: l10n.onBoardingTitleOne,
        description: l10n.onBoardingDescriptionOne,
        image: AppAssets.onBoardingOneBackground,
      ),
      OnboardingContent(
        title: l10n.onBoardingTitleTwo,
        description: l10n.onBoardingDescriptionTwo,
        image: AppAssets.onBoardingTwoBackground,
      ),
      OnboardingContent(
        title: l10n.onBoardingTitleThree,
        description: l10n.onBoardingDescriptionThree,
        image: AppAssets.onBoardingThreeBackground,
      ),
    ];

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
              itemCount: contents.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  contents[index].image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.scaleDown,
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: OnboardingBottomSheet(
                contents: contents,
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
