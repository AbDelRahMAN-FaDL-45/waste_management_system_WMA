import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class MapBackground extends StatelessWidget {
  const MapBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _MapPainter(),
      child: Stack(
        children: [
          // Trash bin icon top-left area
          Positioned(
            top: 80,
            left: 60,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.gray,
                size: 20,
              ),
            ),
          ),

          // Center Nearest Pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'NEAREST',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF5F5F5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1.5;

    const spacing = 50.0;

    // Grid lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Roads (thicker white-ish)
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4;

    // Curved road 1
    final path1 = Path();
    path1.moveTo(size.width * 0.1, size.height * 0.3);
    path1.quadraticBezierTo(
      size.width * 0.4, size.height * 0.2,
      size.width * 0.7, size.height * 0.5,
    );
    path1.quadraticBezierTo(
      size.width * 0.9, size.height * 0.7,
      size.width * 0.8, size.height * 0.9,
    );
    canvas.drawPath(path1, roadPaint);

    // Curved road 2
    final path2 = Path();
    path2.moveTo(size.width * 0.9, size.height * 0.1);
    path2.quadraticBezierTo(
      size.width * 0.5, size.height * 0.3,
      size.width * 0.3, size.height * 0.6,
    );
    path2.quadraticBezierTo(
      size.width * 0.1, size.height * 0.8,
      size.width * 0.2, size.height * 0.95,
    );
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}