import 'package:flutter/material.dart';
import 'package:smartbins/core/app_colors.dart';
import 'package:smartbins/views/home/widgets/route_delta_card.dart';
import 'package:smartbins/views/home/widgets/search_bar.dart';
import 'package:smartbins/views/home/widgets/stats_row.dart';
import 'package:smartbins/views/home/widgets/system_health_card.dart';
import 'package:smartbins/views/map/widgets/map_page.dart';
import 'package:smartbins/widgets/app_bottom_nav.dart';
import 'package:smartbins/widgets/custom_button.dart';
import 'package:smartbins/widgets/smartbins_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _goToMap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MapPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Real Map Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
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

                  // Search Bar
                  const HomeSearchBar(),
                  const SizedBox(height: 24),

                  // System Health
                  const SystemHealthCard(),
                  const SizedBox(height: 16),

                  // Stats Row
                  const StatsRow(),
                  const SizedBox(height: 16),

                  // Route Delta
                  const RouteDeltaCard(),
                  const SizedBox(height: 24),

                  // CTA Button
                  CustomButton(
                    text: 'CHECK NEAREST BIN STATUS',
                    onPressed: _goToMap,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Nav — uses shared widget
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}