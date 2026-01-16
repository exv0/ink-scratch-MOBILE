// lib/features/splash/presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/presentation/pages/onboarding_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/view_model/auth_viewmodel_provider.dart'; // ✅ Changed import
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNavigation();
    });
  }

  Future<void> _checkNavigation() async {
    // Check current user through the ViewModel
    await ref.read(authViewModelProvider.notifier).checkCurrentUser();

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final hive = HiveService();
    final isOnboardingSeen = hive.isOnboardingSeen();
    final authState = ref.read(authViewModelProvider);

    Widget nextPage;
    if (!isOnboardingSeen) {
      nextPage = const OnboardingPage();
    } else if (!authState.isAuthenticated || authState.currentUser == null) {
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
            const Icon(Icons.book_rounded, size: 150, color: Colors.white),
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
