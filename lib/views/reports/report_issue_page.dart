import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/home/widgets/home_page.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/views/reports/report_submitted_page.dart';
import 'package:smartbins/views/reports/widgets/photo_upload.dart';
import 'package:smartbins/views/reports/widgets/report_map_card.dart';
import 'package:smartbins/widgets/custom_button.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController _descriptionController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() => _charCount = _descriptionController.text.length);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ReportSubmittedPage()),
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
                'Help us keep it clean',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.dark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Report infrastructure issues in real-time to maintain your sector efficiency.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Map Card
              const ReportMapCard(),
              const SizedBox(height: 24),

              // Issue Details
              const Text(
                'ISSUE DETAILS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  maxLength: 500,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Describe the situation...',
                    hintStyle: TextStyle(
                      color: AppColors.gray,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$_charCount / 500',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Photo Upload
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ADD A PHOTO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'OPTIONAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.gray.withOpacity(0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const PhotoUpload(),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: 'SUBMIT REPORT',
                onPressed: _submitReport,
                showArrow: true,
              ),
              const SizedBox(height: 16),

              // Response time
              Center(
                child: Text(
                  'ESTIMATED RESPONSE TIME: < 2 HOURS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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
            _buildNavItem(Icons.bar_chart_outlined, 'REPORTS', 2),
            _buildNavItem(Icons.settings_outlined, 'SETTINGS', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = index == 2;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MapPage()),
          );
        }
      },
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