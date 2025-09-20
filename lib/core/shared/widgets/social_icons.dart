import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickrider/core/constants/constant_exports.dart';

import '../../../l10n/app_localizations.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(l10n.socialMediaFolow, style: AppTextStyles.descriptionText),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.tiktok, color: Colors.grey, size: 28),
            SizedBox(width: 24),
            FaIcon(FontAwesomeIcons.snapchat, color: Colors.grey, size: 28),
            SizedBox(width: 24),
            FaIcon(FontAwesomeIcons.instagram, color: Colors.grey, size: 28),
            SizedBox(width: 24),
            FaIcon(FontAwesomeIcons.whatsapp, color: Colors.grey, size: 28),
          ],
        ),
      ],
    );
  }
}
