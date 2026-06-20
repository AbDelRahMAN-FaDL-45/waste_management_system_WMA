import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/providers/auth_provider.dart';
import 'package:smartbins/views/auth/widgets/change_password_page.dart';
import 'package:smartbins/views/auth/widgets/login_page.dart';
import 'package:smartbins/views/settings/edit_profile_page.dart';
import 'package:smartbins/views/settings/widgets/profile_header.dart';
import 'package:smartbins/views/settings/widgets/settings_nav_item.dart';
import 'package:smartbins/views/settings/widgets/settings_section.dart';
import 'package:smartbins/views/settings/widgets/settings_toggle.dart';
import 'package:smartbins/widgets/app_bottom_nav.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.currentUser == null && auth.isAuthenticated) {
        _loadCurrentUser(auth);
      }
    });
  }

  Future<void> _loadCurrentUser(AuthProvider auth) async {
    try {
      debugPrint('🔄 Loading current user in Settings...');
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Failed to load user in settings: $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    ));
  }

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out?',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out of SmartBins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL',
                style: TextStyle(color: AppColors.gray)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('LOG OUT'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !context.mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final success = await authProvider.logout();

      if (context.mounted) {
        if (success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
          );
        } else {
          _showError(context, authProvider.error ?? 'Logout failed');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Logout failed. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;

        final displayName = user != null
            ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
            : 'Loading...';

        final displayEmail = user?.email ?? 'No email available';

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
                    children: [SmartBinsLogo(), SizedBox(width: 40)],
                  ),
                  const SizedBox(height: 32),

                  ProfileHeader(
                    name: displayName.toUpperCase(),
                    email: displayEmail,
                    showEditButton: true,
                    onEditProfile: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
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
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordPage(),
                            ),
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
                  const SizedBox(height: 32),

                  GestureDetector(
                    onTap: () => _logout(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 18),
                        SizedBox(width: 8),
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
                    'SYSTEM VERSION V2.4.0-STABLE',
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
                    'SEC. REF: 88-0412-7XX',
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
          bottomNavigationBar: const AppBottomNav(currentIndex: 2),
        );
      },
    );
  }
}