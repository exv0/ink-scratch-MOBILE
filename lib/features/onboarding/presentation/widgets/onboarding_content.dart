import 'package:flutter/material.dart';
import 'package:ink_scratch/features/onboarding/domain/entities/onboarding_item.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // For now, use icons instead of images until assets are added
          Icon(
            _getIconForPage(item.title),
            size: 150,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 40),
          Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            item.subtitle,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage(String title) {
    if (title.contains("Discover")) {
      return Icons.search;
    } else if (title.contains("Read")) {
      return Icons.book;
    } else {
      return Icons.track_changes;
    }
  }
}
