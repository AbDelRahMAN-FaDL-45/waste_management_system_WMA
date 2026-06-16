import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/bin_detail/widgets/activity_list.dart';
import 'package:smartbins/views/bin_detail/widgets/bin_header_card.dart';
import 'package:smartbins/views/bin_detail/widgets/fullness_indicator.dart';
import 'package:smartbins/views/bin_detail/widgets/location_card.dart';
import 'package:smartbins/views/bin_detail/widgets/mini_map.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class BinDetailPage extends StatefulWidget {
  const BinDetailPage({super.key});

  @override
  State<BinDetailPage> createState() => _BinDetailPageState();
}

class _BinDetailPageState extends State<BinDetailPage> {
  int _currentNavIndex = 1;

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MapPage()),
      );
    } else if (index == 2) {
      _showComingSoon('Reports');
    } else if (index == 3) {
      _showComingSoon('Settings');
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
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
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
              const SizedBox(height: 24),

              // Bin Header Card (Dark bin + ONLINE)
              const BinHeaderCard(),
              const SizedBox(height: 32),

              // Fullness Level (95%)
              const FullnessIndicator(),
              const SizedBox(height: 32),

              // Location + MARK AS CLEANED
              const LocationCard(),
              const SizedBox(height: 32),

              // Mini Map
              const MiniMap(),
              const SizedBox(height: 32),

              // Recent Activity
              const ActivityList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.lightGray,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.grid_view_rounded, 'HOME', 0),
              _buildNavItem(Icons.map_outlined, 'MAP', 1),
              _buildNavItem(Icons.bar_chart_outlined, 'REPORTS', 2),
              _buildNavItem(Icons.settings_outlined, 'SETTINGS', 3),
            ],
          ),
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