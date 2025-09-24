import 'package:flutter/material.dart';
import 'package:quickrider/core/constants/app_colors.dart';
import 'package:quickrider/core/constants/app_text_style.dart';
import 'package:quickrider/l10n/app_localizations.dart';

class CustomAlertDialog {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String? confirmButtonText,
    String? cancelButtonText,
    IconData? titleIcon,
    Color titleIconColor = Colors.black,
    Color? confirmButtonColor,
    Color? confirmButtonTextColor,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              if (titleIcon != null) ...[
                Icon(titleIcon, color: titleIconColor, size: 28),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: AppTextStyles.textStyle14(),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              icon: const Icon(Icons.cancel, size: 20),
              label: Text(
                cancelButtonText ?? l10n.cancel,
                style: AppTextStyles.textStyle16()
                    .copyWith(color: Colors.grey[700]),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 0,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                onConfirm.call();
                Navigator.of(dialogContext).pop();
              },
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                confirmButtonText ?? l10n.confirm,
                style: AppTextStyles.textStyle16()
                    .copyWith(color: confirmButtonTextColor ?? Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: confirmButtonTextColor ?? Colors.white,
                backgroundColor: confirmButtonColor ?? AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 3,
              ),
            ),
          ],
        );
      },
    );
  }
}
