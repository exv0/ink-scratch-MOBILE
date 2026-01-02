import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/hive/hive_service.dart';
import 'app/themes/theme_provider.dart'; // ← This is the key import
import 'features/splash/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider); // ← Watches the current theme

    return MaterialApp(
      title: 'Ink Scratch',
      debugShowCheckedModeBanner: false,
      theme: theme, // ← Applies your custom light/dark theme
      themeMode: ThemeMode
          .system, // ← Respects system preference (can be changed later)
      home: const SplashPage(),
    );
  }
}
