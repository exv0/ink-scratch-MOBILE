import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

enum ThemeModeOption { light, dark, system }

final themeModeProvider = StateProvider<ThemeModeOption>(
  (ref) => ThemeModeOption.system,
);

final themeProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeModeProvider);

  switch (mode) {
    case ThemeModeOption.light:
      return AppTheme.lightTheme;
    case ThemeModeOption.dark:
      return AppTheme.darkTheme;
    case ThemeModeOption.system:
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark
          ? AppTheme.darkTheme
          : AppTheme.lightTheme;
  }
});
