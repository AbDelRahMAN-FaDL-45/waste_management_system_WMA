import 'package:flutter/material.dart';
import 'package:smartbins/widgets/custom_button.dart';
import 'package:smartbins/widgets/page_indicator.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

import '../../../core/app_colors.dart';

class IoTSlide extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const IoTSlide({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SmartBinsLogo(),
                TextButton(
                  onPressed: onSkip,
                  child: const Text(
                    'SKIP',
                    style: TextStyle(
                      color: AppColors.gray,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Illustration Area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IoT Sensor Illustration
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // U-Shape Bracket
                      Container(
                        width: 220,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            width: 180,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      // Green Fill Bar
                      Positioned(
                        top: 20,
                        child: Container(
                          width: 160,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGreen.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Signal Waves
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(),
                      const SizedBox(width: 12),
                      _buildWave(30),
                      const SizedBox(width: 8),
                      _buildWave(45),
                      const SizedBox(width: 8),
                      _buildWave(60),
                      const SizedBox(width: 12),
                      _buildDot(),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // LIVE TRACKING Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'LIVE TRACKING',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Title
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  fontFamily: 'Inter',
                ),
                children: [
                  TextSpan(
                    text: 'CHECK BEFORE\n',
                    style: TextStyle(color: AppColors.dark),
                  ),
                  TextSpan(
                    text: 'YOU GO',
                    style: TextStyle(color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Subtitle
            const Text(
              'Know if your bin is empty or full using IoT real-time tracking.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // Indicator
            const PageIndicator(count: 4, currentIndex: 1),
            const SizedBox(height: 24),

            // Button
            CustomButton(
              text: 'CONTINUE',
              onPressed: onNext,
              showArrow: true,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildWave(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGreen.withOpacity(0.4),
          width: 2,
        ),
      ),
    );
  }
}