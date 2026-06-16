import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/views/reports/report_issue_page.dart';
import 'package:smartbins/views/reports/widgets/alert_item.dart';
import 'package:smartbins/views/reports/widgets/insight_card.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  int _currentNavIndex = 2;

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MapPage()),
      );
    } else if (index == 3) {
      _showComingSoon('Settings');
    } else {
      setState(() => _currentNavIndex = index);
    }
  }

  void _showComingSoon(String feature) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction, color: AppColors.primaryGreen, size: 48),
            const SizedBox(height: 16),
            Text(
              '$feature Coming Soon',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is under development.',
              style: TextStyle(color: AppColors.gray),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('GOT IT', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SmartBinsLogo(),
                  GestureDetector(
                    onTap: () => _showComingSoon('Profile'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4C4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.dark,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Activity Monitor Label
              const Text(
                'ACTIVITY MONITOR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),

              // Latest Alerts Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest Alerts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.dark,
                    ),
                  ),
                  Row(
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
                        'LIVE UPDATES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreen,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Alert 1
              const AlertItem(
                icon: Icons.delete_outline,
                iconBg: AppColors.badgeBg,
                iconColor: AppColors.primaryGreen,
                title: 'Bin #BW-882 Empty',
                description: 'Bin #BW-882 is now empty and ready for use. Sensor recalibration complete.',
                time: '2M AGO',
                isLive: true,
              ),
              const SizedBox(height: 12),

              // Alert 2
              const AlertItem(
                icon: Icons.local_shipping_outlined,
                iconBg: AppColors.lightGray,
                iconColor: AppColors.dark,
                title: 'Route Update',
                description: 'Waste collection delayed by 1 hour due to heavy traffic on Main St. Sector B.',
                time: '45M AGO',
              ),
              const SizedBox(height: 12),

              // Alert 3
              const AlertItem(
                icon: Icons.battery_alert_outlined,
                iconBg: AppColors.badgeBg,
                iconColor: AppColors.primaryGreen,
                title: 'Maintenance Alert',
                description: 'Sensor battery low on Bin #BW-412. Scheduling technician for tomorrow morning.',
                time: '5H AGO',
                isLive: true,
              ),
              const SizedBox(height: 12),

              // Alert 4
              AlertItem(
                icon: Icons.check_circle_outline,
                iconBg: AppColors.lightGray,
                iconColor: AppColors.gray,
                title: 'Pickup Confirmed',
                description: 'Monthly report for Sector A is now ready for review in the Stats panel.',
                time: '3H AGO',
              ),
              const SizedBox(height: 24),

              // Monthly Insight Card
              const InsightCard(),
              const SizedBox(height: 24),

              // Yesterday Section
              const Text(
                'YESTERDAY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),

              // Yesterday Alert
              AlertItem(
                icon: Icons.person_outline,
                iconBg: AppColors.lightGray,
                iconColor: AppColors.gray,
                title: 'New Driver Assigned',
                description: 'Marcus J. has been assigned to the North Sector waste collection route.',
                time: '1D AGO',
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // FAB for new report
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ReportIssuePage()),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'NEW REPORT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Bottom Nav
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.lightGray, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.grid_view_rounded, 'HOME', 0),
            _buildNavItem(Icons.map_outlined, 'MAP', 1),
            _buildNavItem(Icons.bar_chart_outlined, 'ALERTS', 2),
            _buildNavItem(Icons.settings_outlined, 'SETTINGS', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = index == _currentNavIndex;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primaryGreen : AppColors.gray,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.primaryGreen : AppColors.gray,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}