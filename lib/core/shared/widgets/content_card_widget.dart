import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReusableCard extends StatelessWidget {
  final String? iconPath;
  final String? text;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? button;

  const ReusableCard({
    super.key,
    this.iconPath,
    this.text,
    this.buttonText,
    this.onButtonPressed,
    this.horizontalPadding,
    this.verticalPadding,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 70.0,
          vertical: verticalPadding ?? 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null)
              SvgPicture.asset(iconPath!, height: 100, width: 100),
            if (iconPath != null) const SizedBox(height: 20),
            if (text != null) Text(text!, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            button ??
                (buttonText != null
                    ? ElevatedButton(
                        onPressed: onButtonPressed,
                        child: Text(buttonText!),
                      )
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
