import 'package:flutter/material.dart';
import 'package:quickrider/core/constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
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
  final int? maxLength;
  final bool enabled;

  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.controller,
    this.fillColor = AppColors.fieldfilled,
    this.borderColor,
    this.prefixIconColor,
    this.keyboardType,
    this.borderRadius = 12.0,
    this.maxLength,
    this.enabled = true,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      enabled: enabled,
      validator: validator,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: prefixIconColor ?? Colors.grey.shade500)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon: Icon(suffixIcon, color: Colors.grey.withAlpha(200)),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor ?? Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        hintText: hintText,
        counterText: "",
      ),
    );
  }
}
