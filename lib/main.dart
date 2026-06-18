import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/theme/app_theme.dart';
import 'core/services/api_service.dart';
import 'providers/auth_provider.dart';
import 'views/auth/widgets/login_page.dart';
import 'views/home/widgets/home_page.dart';
import 'views/onboarding/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService().loadTokens();
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
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (auth.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00E676)),
        ),
      );
    }
    if (auth.isAuthenticated) return const HomePage();
    return const OnboardingPage();
  }
}