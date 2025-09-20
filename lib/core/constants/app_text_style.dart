import 'package:flutter/material.dart';

import 'constant_exports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const String _fontFamily = 'Tajawal';

  static TextStyle _baseStyle(
    double fontSize, {
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Grid Item Labels
  static TextStyle get gridItemLabel =>
      _baseStyle(16, fontWeight: FontWeight.bold);

  // Dialog Titles
  static TextStyle get dialogTitle =>
      _baseStyle(18, fontWeight: FontWeight.bold);

  // Dialog Buttons
  static TextStyle get dialogButton =>
      _baseStyle(16, fontWeight: FontWeight.w600);

  // Optional Text
  static TextStyle get optionalText =>
      _baseStyle(18, fontWeight: FontWeight.bold, color: AppColors.primary);

  // Gradient Text
  static TextStyle get gradientText =>
      _baseStyle(16, fontWeight: FontWeight.w600, color: Colors.white);

  // Section Titles
  static TextStyle get sectionTitle =>
      _baseStyle(20, fontWeight: FontWeight.bold, color: Colors.black87);

  // Description Text
  static TextStyle get descriptionText => _baseStyle(14, color: Colors.black54);

  // Input Field Hints
  static TextStyle get inputHintText => _baseStyle(14, color: Colors.grey);

  // Input Field Text
  static TextStyle get inputFieldText => _baseStyle(14, color: Colors.black);

  // Small Buttons
  static TextStyle get smallButton =>
      _baseStyle(14, fontWeight: FontWeight.w500, color: Colors.white);

  // Card Titles
  static TextStyle get cardTitle =>
      _baseStyle(16, fontWeight: FontWeight.bold, color: Colors.black87);

  // Card Subtitles
  static TextStyle get cardSubtitle => _baseStyle(14, color: Colors.black54);

  // Error Messages
  static TextStyle get errorText =>
      _baseStyle(14, fontWeight: FontWeight.bold, color: Colors.red);

  // Success Messages
  static TextStyle get successText =>
      _baseStyle(12, fontWeight: FontWeight.bold, color: Colors.green);

  // AppBar Titles
  static TextStyle get appBarTitle =>
      _baseStyle(20, fontWeight: FontWeight.bold, color: Colors.white);

  // Dialog Descriptions
  static TextStyle get dialogDescription =>
      _baseStyle(14, color: Colors.black87);

  // Highlighted Text
  static TextStyle get highlightedText =>
      _baseStyle(16, fontWeight: FontWeight.bold, color: Colors.blue);

  // Additional generic responsive text helpers
  static TextStyle textStyle18({Color color = Colors.black}) =>
      _baseStyle(18, color: color);

  static TextStyle textStyle16({Color color = Colors.black}) =>
      _baseStyle(16, color: color);

  static TextStyle textStyle14({Color color = Colors.black}) =>
      _baseStyle(14, color: color);

  static TextStyle textStyle12({Color color = Colors.black}) =>
      _baseStyle(12, color: color);
}
