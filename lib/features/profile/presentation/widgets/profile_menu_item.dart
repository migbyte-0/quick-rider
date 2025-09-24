import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickrider/core/constants/constant_exports.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.fieldfilled,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  height: 24.r,
                  width: 24.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: color ?? Colors.black87,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.r,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
