import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final String? logoType;
  const AppLogo({this.height, this.width, super.key, required this.logoType});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(logoType!, height: height, width: width);
  }
}
