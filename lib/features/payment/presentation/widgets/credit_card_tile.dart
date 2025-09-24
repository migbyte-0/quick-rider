import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/widgets/custom_alert_dialog.dart';
import 'package:quickrider/features/payment/domain/entities/credit_card_entity.dart';
import 'package:quickrider/l10n/app_localizations.dart';

class CreditCardTile extends StatelessWidget {
  final CreditCardEntity card;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  const CreditCardTile({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.credit_card, size: 24.w, color: Colors.grey),
                  SizedBox(width: 16.w),
                  Text(
                    '**** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                    style: AppTextStyles.textStyle18()
                        .copyWith(color: Colors.black),
                  ),
                  const Spacer(),
                  Radio<bool>(
                    value: true,
                    groupValue: isSelected,
                    onChanged: (bool? value) {
                      onTap.call();
                    },
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
              if (isSelected)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: card.isDefault ? null : onSetDefault,
                        icon: Icon(Icons.star,
                            color: card.isDefault
                                ? Colors.grey
                                : AppColors.secondary),
                        label: Text(
                          card.isDefault
                              ? l10n.defaultLabel
                              : l10n.setAsDefault,
                          style: AppTextStyles.textStyle14().copyWith(
                              color: card.isDefault
                                  ? Colors.grey
                                  : AppColors.secondary),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: card.isDefault
                              ? Colors.grey
                              : AppColors.secondary,
                          backgroundColor: card.isDefault
                              ? Colors.grey.withValues(alpha: 0.1)
                              : AppColors.secondary.withValues(
                                  alpha: (0.1),
                                ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => CustomAlertDialog.show(
                          context,
                          title: l10n.deleteCardTitle,
                          content: l10n.deleteCardConfirmation(card.cardNumber
                              .substring(card.cardNumber.length - 4)),
                          onConfirm: onDelete,
                          confirmButtonText: l10n.delete,
                          confirmButtonColor: AppColors.error,
                          confirmButtonTextColor: Colors.white,
                          titleIcon: Icons.warning_rounded,
                          titleIconColor: AppColors.error,
                        ),
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        label: Text(
                          l10n.delete,
                          style: AppTextStyles.textStyle14()
                              .copyWith(color: AppColors.error),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          backgroundColor:
                              AppColors.error.withValues(alpha: 0.1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
