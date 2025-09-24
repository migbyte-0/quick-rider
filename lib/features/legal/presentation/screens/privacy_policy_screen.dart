import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:quickrider/core/shared/widgets/custom_app_bar.dart';
import 'package:quickrider/core/constants/app_colors.dart';
import 'package:quickrider/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_text_style.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: l10n.privacyPolicyScreenTitle),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Markdown(
          data: l10n.privacyPolicyContent,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            h1: AppTextStyles.sectionTitle.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            h2: AppTextStyles.cardTitle.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            h3: AppTextStyles.cardTitle.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            p: AppTextStyles.descriptionText.copyWith(
              fontSize: 15.sp,
              color: Colors.grey[800],
              height: 1.5,
            ),
            strong: AppTextStyles.descriptionText.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            listBullet: AppTextStyles.descriptionText.copyWith(
              fontSize: 15.sp,
              color: Colors.grey[800],
            ),

            checkbox: AppTextStyles.descriptionText.copyWith(
              fontSize: 15.sp,
              color: Colors.grey[800],
            ),
            a: AppTextStyles.descriptionText.copyWith(
              fontSize: 15.sp,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
          selectable: true,
          onTapLink: (text, href, title) async {
            if (href != null) {
              final uri = Uri.parse(href);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $href')),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
