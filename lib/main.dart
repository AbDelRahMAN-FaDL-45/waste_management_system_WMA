import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/theme/app_theme.dart';
import 'core/services/api_service.dart';
import 'providers/auth_provider.dart';
import 'views/onboarding/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService().loadTokens();
  runApp(const SmartBinsApp());
}

class SmartBinsApp extends StatelessWidget {
  const SmartBinsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'SmartBins',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const OnboardingPage(),
      ),
    );
  }
}