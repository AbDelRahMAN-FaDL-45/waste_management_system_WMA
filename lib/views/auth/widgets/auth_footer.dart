import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AuthFooter extends StatelessWidget {
  final String leftText;
  final String actionText;
  final VoidCallback onAction;

  const AuthFooter({
    super.key,
    required this.leftText,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          leftText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.dark,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}