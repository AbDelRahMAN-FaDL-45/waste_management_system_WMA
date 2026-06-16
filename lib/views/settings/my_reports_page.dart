import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/views/reports/alerts_page.dart';
import 'package:smartbins/views/settings/widgets/report_filter_chip.dart';
import 'package:smartbins/views/settings/widgets/report_list_item.dart';
import 'package:smartbins/views/settings/widgets/report_stat_card.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  int _currentNavIndex = 3;
  String _selectedFilter = 'ALL';

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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AlertsPage()),
      );
    }
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
                    onTap: () {},
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

              // Title
              const Text(
                'My Reports',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tracking your environmental impact',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray,
                ),
              ),
              const SizedBox(height: 24),

              // Stats Cards
              Row(
                children: [
                  const ReportStatCard(
                    label: 'TOTAL SUBMITTED',
                    value: '24',
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  ReportStatCard(
                    label: 'RESOLVED',
                    value: '18',
                    color: AppColors.dark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Filter Chips
              Row(
                children: [
                  ReportFilterChip(
                    label: 'ALL',
                    isActive: _selectedFilter == 'ALL',
                    onTap: () => setState(() => _selectedFilter = 'ALL'),
                  ),
                  const SizedBox(width: 8),
                  ReportFilterChip(
                    label: 'PENDING',
                    isActive: _selectedFilter == 'PENDING',
                    onTap: () => setState(() => _selectedFilter = 'PENDING'),
                  ),
                  const SizedBox(width: 8),
                  ReportFilterChip(
                    label: 'RESOLVED',
                    isActive: _selectedFilter == 'RESOLVED',
                    onTap: () => setState(() => _selectedFilter = 'RESOLVED'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Report List
              const ReportListItem(
                date: 'OCT 24, 2024',
                time: '09:15 AM',
                title: 'Bin Full at 123 Market St',
                subtitle: 'Pickup Request • Downtown',
                status: 'RESOLVED',
                isResolved: true,
              ),
              const SizedBox(height: 12),
              const ReportListItem(
                date: 'OCT 26, 2024',
                time: '1:30 PM',
                title: 'Damaged Lid at Park Ave',
                subtitle: 'Maintenance • North Sector',
                status: 'PENDING',
                isResolved: false,
              ),
              const SizedBox(height: 12),
              const ReportListItem(
                date: 'OCT 28, 2024',
                time: '11:00 AM',
                title: 'Illegal Dumping at Pier 5',
                subtitle: 'Violation • Waterfront',
                status: 'PENDING',
                isResolved: false,
              ),
              const SizedBox(height: 12),
              const ReportListItem(
                date: 'OCT 29, 2024',
                time: '08:45 AM',
                title: 'Bin Full at Station Square',
                subtitle: 'Pickup Request • Transport Hub',
                status: 'RESOLVED',
                isResolved: true,
              ),
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