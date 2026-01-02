import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // ← This fixes StateProvider
import 'dart:ui'; // ← This fixes PlatformDispatcher

import 'app_theme.dart';

enum ThemeModeOption { light, dark, system }

/// User's selected theme mode (light, dark, or system)
final themeModeProvider = StateProvider<ThemeModeOption>((ref) {
  return ThemeModeOption.system;
});

/// The actual ThemeData used by the app
final themeProvider = Provider<ThemeData>((ref) {
  final selectedMode = ref.watch(themeModeProvider);

  // Get current system brightness (non-deprecated, works without context)
  final platformBrightness = PlatformDispatcher.instance.platformBrightness;

  final isDark = switch (selectedMode) {
    ThemeModeOption.light => false,
    ThemeModeOption.dark => true,
    ThemeModeOption.system => platformBrightness == Brightness.dark,
  };

  return isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
});
