import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class MiniMap extends StatelessWidget {
  const MiniMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Map Background
            CustomPaint(
              size: Size.infinite,
              painter: _MiniMapPainter(),
            ),

            // Zoom Controls
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
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
                child: Column(
                  children: [
                    _buildZoomButton(Icons.add),
                    Container(
                      height: 1,
                      color: AppColors.lightGray,
                    ),
                    _buildZoomButton(Icons.remove),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: AppColors.dark,
        size: 20,
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F5E9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFC8E6C9)
      ..strokeWidth = 1.5;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Road
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );

    // Center Pin
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Pin shadow
    canvas.drawCircle(
      Offset(centerX, centerY + 4),
      24,
      Paint()..color = AppColors.primaryGreen.withOpacity(0.3),
    );

    // Pin circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      20,
      Paint()..color = AppColors.primaryGreen,
    );

    // Pause icon in center
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '⏸',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2),
    );

    // Label below
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'BW-882 LOCATION',
        style: TextStyle(
          color: AppColors.dark,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(
      canvas,
      Offset(centerX - labelPainter.width / 2, centerY + 28),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}