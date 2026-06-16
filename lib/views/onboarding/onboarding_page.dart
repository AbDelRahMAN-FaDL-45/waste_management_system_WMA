import 'package:flutter/material.dart';
import 'package:smartbins/views/onboarding/widget/iot_slide.dart';
import 'package:smartbins/views/onboarding/widget/map_slide.dart';
import 'package:smartbins/views/onboarding/widget/report_slide.dart';
import 'package:smartbins/views/onboarding/widget/welcome_slide.dart';

import '../auth/widgets/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _onNext() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToHome();
    }
  }

  void _onSkip() => _goToHome();

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          WelcomeSlide(onNext: _onNext, onSkip: _onSkip),
          IoTSlide(onNext: _onNext, onSkip: _onSkip),
          MapSlide(onNext: _onNext, onSkip: _onSkip),
          ReportSlide(onNext: _onNext, onSkip: _onSkip),
        ],
      ),
    );
  }
}