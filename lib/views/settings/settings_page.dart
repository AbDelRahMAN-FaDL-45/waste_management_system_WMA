import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/providers/auth_provider.dart';
import 'package:smartbins/views/auth/widgets/change_password_page.dart';
import 'package:smartbins/views/auth/widgets/login_page.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/views/reports/alerts_page.dart';
import 'package:smartbins/views/settings/edit_profile_page.dart';
import 'package:smartbins/views/settings/my_reports_page.dart';
import 'package:smartbins/views/settings/widgets/profile_header.dart';
import 'package:smartbins/views/settings/widgets/settings_nav_item.dart';
import 'package:smartbins/views/settings/widgets/settings_section.dart';
import 'package:smartbins/views/settings/widgets/settings_toggle.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentNavIndex = 3;

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
    } else {
      setState(() => _currentNavIndex = index);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out of SmartBins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.gray)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final success = await authProvider.logout();
              if (mounted) {
                if (success) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                  );
                } else {
                  _showError(authProvider.error ?? 'Logout failed');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('LOG OUT'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final displayName = user != null
        ? '${user.firstName} ${user.lastName}'.toUpperCase()
        : 'LOADING...';
    final displayEmail = user?.email ?? 'a.rivera@binwise-industrial.com';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmartBinsLogo(),
                  SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 32),

              ProfileHeader(
                name: displayName,
                email: displayEmail,
                showEditButton: true,
                onEditProfile: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 32),

              SettingsSection(
                title: 'NOTIFICATION SETTINGS',
                children: [
                  SettingsToggle(
                    title: 'Push Notifications',
                    subtitle: 'SYSTEM ALERTS & CRITICAL UPDATES',
                    initialValue: true,
                    onChanged: (value) {},
                  ),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  SettingsToggle(
                    title: 'Email Reports',
                    subtitle: 'WEEKLY EFFICIENCY ANALYTICS',
                    initialValue: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SettingsSection(
                title: 'ACCOUNT SECURITY',
                children: [
                  SettingsNavItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                      );
                    },
                  ),
                  SettingsNavItem(
                    icon: Icons.shield_outlined,
                    title: 'Two-Factor Authentication',
                    subtitle: 'OFF',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SettingsSection(
                title: 'SUPPORT',
                children: [
                  SettingsNavItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'DOCUMENTATION & SUPPORT',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SettingsSection(
                title: 'REPORTS',
                children: [
                  SettingsNavItem(
                    icon: Icons.description_outlined,
                    title: 'My Reports',
                    subtitle: 'VIEW SUBMITTED REPORTS',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MyReportsPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              GestureDetector(
                onTap: _logout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'LOG OUT OF SMARTBINS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.red,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "SYSTEM VERSION V2.4.0-STABLE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.withOpacity(0.5),
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                "SEC. REF: 88-0412-7XX",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray.withOpacity(0.5),
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

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