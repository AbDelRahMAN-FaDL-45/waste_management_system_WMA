import 'package:flutter/material.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

import '../../../core/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final bool showSystemVersion;

  const AuthHeader({
    super.key,
    this.showSystemVersion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SmartBinsLogo(),
        if (showSystemVersion)
          const Text(
            'V 2.04 SYSTEM',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.gray,
              letterSpacing: 0.5,
            ),
          ),
      ],
    );
  }
}