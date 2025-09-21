import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const primary = Color(0xFF00C9B8);
  static const secondary = Color(0xFF3884FF);
  static const fieldfilled = Color(0xFFF4F5F9);
  // Gradient Colors
  static const gradientDark = Color(0xFF181759);
  static const gradientBlue = Color(0xFF28167C);
  static const gradientPurple = Color(0xFFCA71C7);
  static const gradientPink = Color(0xFFD57CA9);

  static const gradientColors = [
    gradientDark,
    gradientBlue,
    gradientPurple,
    gradientPink,
  ];

  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}
