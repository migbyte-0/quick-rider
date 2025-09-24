import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/shared/widgets/custom_app_bar.dart'; // Import if you use it
import 'package:quickrider/features/legal/presentation/widgets/expandable_faq_card.dart';
import 'package:quickrider/l10n/app_localizations.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Map<String, String>> faqs = [
      {'question': l10n.faqQuestion1, 'answer': l10n.faqAnswer1},
      {'question': l10n.faqQuestion2, 'answer': l10n.faqAnswer2},
      {'question': l10n.faqQuestion3, 'answer': l10n.faqAnswer3},
      {'question': l10n.faqQuestion4, 'answer': l10n.faqAnswer4},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: l10n.faqScreenTitle),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return ExpandableFaqCard(
              question: faqs[index]['question']!,
              answer: faqs[index]['answer']!,
            );
          },
        ),
      ),
    );
  }
}
