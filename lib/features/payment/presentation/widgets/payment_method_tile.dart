import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/constant_exports.dart';

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final bool isAddCard;
  final VoidCallback? onTap;

  const PaymentMethodTile({
    super.key,
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.isAddCard = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isAddCard) {
      return Card(
        color: Colors.white,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(icon, size: 24.w, color: Colors.grey),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style:
                      AppTextStyles.textStyle18().copyWith(color: Colors.black),
                ),
                const Spacer(),
                Icon(Icons.add, size: 30.w, color: AppColors.primary),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        color: Colors.white,
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: RadioListTile<bool>(
          value: true,
          groupValue: isSelected,
          onChanged: (bool? newValue) {
            if (newValue == true) {
              onTap?.call();
            }
          },
          title: Text(
            title,
            style: AppTextStyles.textStyle18().copyWith(color: Colors.black),
          ),
          secondary: Icon(icon, size: 24.w, color: Colors.grey),
          activeColor: AppColors.primary,
          controlAffinity: ListTileControlAffinity.trailing,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      );
    }
  }
}
