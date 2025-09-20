import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? borderColor;
  final Color? prefixIconColor;
  final TextInputType? keyboardType;
  final double borderRadius;
  final int? maxLength; // Optional max length

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.controller,
    this.fillColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.prefixIconColor,
    this.keyboardType,
    this.borderRadius = 30.0,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: prefixIconColor ?? Theme.of(context).primaryColor,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon: Icon(
                  suffixIcon,
                  color: Colors.grey.withAlpha(200),
                ),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.greenAccent, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        hintText: hintText,
        counterText: "", // Hides the maxLength counter
      ),
    );
  }
}
