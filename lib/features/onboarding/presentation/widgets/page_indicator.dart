import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final PageController controller;
  final int pageCount;

  const OnboardingPageIndicator({
    super.key,
    required this.controller,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: pageCount,
      effect: const ExpandingDotsEffect(
        activeDotColor: Colors.deepPurple,
        dotColor: Colors.grey,
        dotHeight: 8,
        dotWidth: 8,
        expansionFactor: 4,
      ),
    );
  }
}
