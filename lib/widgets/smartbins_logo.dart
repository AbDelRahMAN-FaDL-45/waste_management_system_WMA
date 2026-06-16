import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SmartBinsLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;

  const SmartBinsLogo({
    super.key,
    this.iconSize = 22,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.sensors_rounded,
          color: AppColors.primaryGreen,
          size: iconSize,
        ),
        const SizedBox(width: 6),
        Text(
          'SMARTBINS',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            height: 1,
          ),
        ),
      ],
    );
  }
}