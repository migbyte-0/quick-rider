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

import 'package:quickrider/core/language/cubit/language_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:quickrider/core/shared/widgets/custom_alert_dialog.dart';

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

  Future<void> _launchWhatsApp(
    String phoneNumber,
    String message,
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final cleanedPhoneNumber =
        phoneNumber.startsWith('00') ? phoneNumber.substring(2) : phoneNumber;

    final String whatsappUrl =
        "https://wa.me/$cleanedPhoneNumber?text=${Uri.encodeComponent(message)}";
    final Uri uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.failedToLaunchApp)));
    }
  }

  void _showLanguagePickerDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLocalizations.supportedLocales.map((locale) {
              return ListTile(
                title: Text(
                  _getLanguageName(locale.languageCode),
                  style: AppTextStyles.descriptionText,
                ),
                trailing: context.read<LanguageCubit>().state.locale == locale
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<LanguageCubit>().changeLanguage(locale);
                  Navigator.of(dialogContext).pop();
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel, style: AppTextStyles.textStyle18()),
            ),
          ],
        );
      },
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return languageCode;
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    CustomAlertDialog.show(
      context,
      title: l10n.logoutTitle,
      content: l10n.logoutConfirmation,
      onConfirm: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
      confirmButtonText: l10n.logout,
      confirmButtonColor: AppColors.primary,
      titleIcon: Icons.logout,
      titleIconColor: AppColors.primary,
    );
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
                              onTap: () {
                                Navigator.pushNamed(context, '/payment');
                              },
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.language,
                              text: l10n.language,
                              onTap: () => _showLanguagePickerDialog(context),
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.faq,
                              text: l10n.faq,
                              onTap: () {
                                Navigator.pushNamed(context, '/faq');
                              },
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.privacyPolicy,
                              text: l10n.privacyPolicy,
                              onTap: () {
                                Navigator.pushNamed(context, '/policy');
                              },
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.helpSupport,
                              text: l10n.helpSupport,
                              onTap: () {
                                _launchWhatsApp(
                                  '966544024948',
                                  'Hello, I need help with QuickRider.',
                                  context,
                                );
                              },
                            ),
                            SizedBox(height: 10.h),
                            ProfileMenuItem(
                              icon: AppAssets.logout,
                              text: l10n.logout,
                              onTap: () {
                                _showLogoutConfirmationDialog(context);
                              },
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
