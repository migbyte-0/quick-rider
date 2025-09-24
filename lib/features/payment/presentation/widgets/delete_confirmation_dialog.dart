import 'package:flutter/material.dart';
import 'package:quickrider/core/constants/app_colors.dart';
import 'package:quickrider/core/shared/widgets/custom_alert_dialog.dart';
import 'package:quickrider/l10n/app_localizations.dart';

class DeleteConfirmationDialog {
  static Future<void> show(
    BuildContext context, {
    required String cardId,
    required String cardNumber,
    required VoidCallback onConfirm,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    return CustomAlertDialog.show(
      context,
      title: l10n.deleteCardTitle,
      content: l10n
          .deleteCardConfirmation(cardNumber.substring(cardNumber.length - 4)),
      onConfirm: onConfirm,
      confirmButtonText: l10n.delete,
      confirmButtonColor: AppColors.error,
      confirmButtonTextColor: Colors.white,
      titleIcon: Icons.warning_rounded,
      titleIconColor: AppColors.error,
    );
  }
}
