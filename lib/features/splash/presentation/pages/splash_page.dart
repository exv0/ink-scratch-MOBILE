import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../onboarding/presentation/pages/onboarding_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../../core/services/hive/hive_service.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final hive = HiveService();
    final isOnboardingSeen = await hive.isOnboardingSeen();
    final currentUser = hive.getCurrentUser();

    Widget nextPage;
    if (!isOnboardingSeen) {
      nextPage = const OnboardingPage();
    } else if (currentUser == null) {
      nextPage = const LoginPage();
    } else {
      nextPage = const DashboardPage();
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", width: 150), // Add your app logo
            const SizedBox(height: 20),
            const Text(
              "Ink Scratch",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
