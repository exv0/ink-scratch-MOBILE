import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ink_scratch/core/services/hive/hive_service.dart';
import 'package:ink_scratch/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:ink_scratch/features/auth/presentation/pages/login_page.dart';
import 'package:ink_scratch/features/onboarding/presentation/widgets/page_indicator.dart';

final onboardingPageProvider = StateProvider<int>((ref) => 0);

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      title: "Discover Amazing Mangas",
      subtitle: "Browse thousands of manga and comics from various sources",
    ),
    OnboardingItem(
      title: "Read Anywhere, Anytime",
      subtitle: "Offline reading, dark mode, and customizable viewer",
    ),
    OnboardingItem(
      title: "Track Your Progress",
      subtitle: "Bookmark, history, and continue where you left off",
    ),
  ];

  void _onNext() {
    final current = ref.read(onboardingPageProvider);
    if (current < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await HiveService().setOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingPageProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                ref.read(onboardingPageProvider.notifier).state = index;
              },
              itemBuilder: (context, index) {
                final item = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      // Ink Scratch Logo
                      Image.asset(
                        "assets/images/app_logo.png", // Correct path!
                        height: 240,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 60),

                      // Title
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Subtitle
                      Text(
                        item.subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),
                    ],
                  ),
                );
              },
            ),

            // Bottom Controls
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  OnboardingPageIndicator(
                    controller: _pageController,
                    pageCount: _pages.length,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage != 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        else
                          TextButton(
                            onPressed: _completeOnboarding,
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),

                        ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          child: Text(
                            currentPage == _pages.length - 1
                                ? "Get Started"
                                : "Next",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
