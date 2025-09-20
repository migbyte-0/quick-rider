import 'package:flutter/material.dart';

/// App spacing constants for consistent padding/margin
class AppSpaces {
  // Small spaces
  static const double xs = 4.0;
  static const double sm = 8.0;

  // Medium spaces
  static const double md = 12.0;
  static const double lg = 16.0;

  // Large spaces
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Extra large (for big paddings / margins)
  static const double huge = 48.0;

  /// EdgeInsets helpers
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
}
