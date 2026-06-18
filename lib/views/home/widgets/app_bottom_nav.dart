import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/views/settings/settings_page.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;
    Widget page;
    switch (index) {
      case 0: page = const HomePage(); break;
      case 1: page = const MapPage(); break;
      case 2: page = const SettingsPage(); break;
      default: return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.grid_view_rounded, 'HOME'),
      (Icons.map_outlined, 'MAP'),
      (Icons.settings_outlined, 'SETTINGS'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.lightGray, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => _go(context, i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].$1,
                      color: active ? AppColors.primaryGreen : AppColors.gray,
                      size: 24),
                  const SizedBox(height: 4),
                  Text(items[i].$2,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.primaryGreen
                              : AppColors.gray,
                          letterSpacing: 0.5)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}