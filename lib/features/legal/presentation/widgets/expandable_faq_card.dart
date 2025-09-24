import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/app_colors.dart';

import '../../../../core/constants/app_text_style.dart';

class ExpandableFaqCard extends StatefulWidget {
  final String question;
  final String answer;

  const ExpandableFaqCard({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<ExpandableFaqCard> createState() => _ExpandableFaqCardState();
}

class _ExpandableFaqCardState extends State<ExpandableFaqCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0.w),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                ],
              ),
              if (_isExpanded)
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: MarkdownBody(
                    data: widget.answer,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                        .copyWith(
                          p: AppTextStyles.descriptionText.copyWith(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                    selectable: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
