import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/views/reports/alerts_page.dart';
import 'package:smartbins/views/settings/settings_page.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _navigateTo(BuildContext context, int index) {
    // Don't navigate if already on this page
    if (index == currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const MapPage();
        break;
      case 2:
        page = const AlertsPage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      default:
        return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(icon: Icons.grid_view_rounded, label: 'HOME'),
      _NavItem(icon: Icons.map_outlined, label: 'MAP'),
      _NavItem(icon: Icons.bar_chart_outlined, label: 'REPORTS'),
      _NavItem(icon: Icons.settings_outlined, label: 'SETTINGS'),
    ];

    return Container(
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
          children: List.generate(items.length, (index) {
            final isActive = index == currentIndex;
            return GestureDetector(
              onTap: () => _navigateTo(context, index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[index].icon,
                    color: isActive ? AppColors.primaryGreen : AppColors.gray,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[index].label,
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
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}