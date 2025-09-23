import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/widgets/app_loading.dart';
import 'package:quickrider/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:quickrider/features/profile/presentation/cubits/profile_state.dart';
import 'package:quickrider/l10n/app_localizations.dart';

import 'package:quickrider/features/profile/presentation/widgets/profile_header.dart';
import 'package:quickrider/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          l10n.profileScreenTitle,
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              AppAssets.coloredDecor,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const AppLoading();
              }
              if (state is ProfileError) {
                return Center(
                  child: Text(state.message, style: AppTextStyles.errorText),
                );
              }
              if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(user: state.user),
                      SizedBox(height: 24.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            ProfileMenuItem(
                              icon: AppAssets.notifications,
                              text: l10n.notifications,
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.paymentMethods,
                              text: l10n.paymentMethods,
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.language,
                              text: l10n.language,
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.faq,
                              text: l10n.faq,
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.privacyPolicy,
                              text: l10n.privacyPolicy,
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.helpSupport,
                              text: l10n.helpSupport,
                              onTap: () {},
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.logout,
                              text: l10n.logout,
                              onTap: () {},
                              color: AppColors.error,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
