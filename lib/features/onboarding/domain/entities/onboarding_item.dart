class OnboardingItem {
  final String title;
  final String subtitle;
  final String? imagePath; // Now optional

  OnboardingItem({
    required this.title,
    required this.subtitle,
    this.imagePath, // No longer required
  });
}
