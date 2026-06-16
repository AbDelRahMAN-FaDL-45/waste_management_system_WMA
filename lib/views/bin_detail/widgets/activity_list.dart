import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'RECENT ACTIVITY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.gray,
                letterSpacing: 1,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'VIEW ALL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Activity 1
        _buildActivityItem(
          icon: Icons.recycling_outlined,
          iconBg: AppColors.badgeBg,
          iconColor: AppColors.primaryGreen,
          title: 'Waste Collection',
          date: 'OCT 24, 9:00 AM',
          status: '+100% Space',
          statusColor: AppColors.primaryGreen,
        ),
        const SizedBox(height: 16),

        // Activity 2
        _buildActivityItem(
          icon: Icons.sensors_outlined,
          iconBg: AppColors.lightGray,
          iconColor: AppColors.gray,
          title: 'Sensor Calibration',
          date: 'OCT 22, 12:15 PM',
          status: 'Routine',
          statusColor: AppColors.gray,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}