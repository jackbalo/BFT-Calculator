import 'package:flutter/material.dart';
import 'package:bft_calculator/config/theme.dart';
import 'package:bft_calculator/screens/input_page.dart';
import 'package:bft_calculator/services/preferences_service.dart';
import 'package:bft_calculator/services/theme_provider.dart' as theme_service;
import 'package:bft_calculator/services/haptic_service.dart';

final preferencesService = PreferencesService();
late theme_service.ThemeProvider themeProvider;
late HapticService hapticService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferencesService.init();
  themeProvider = theme_service.ThemeProvider(preferencesService: preferencesService);
  hapticService = HapticService(preferencesService: preferencesService);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<theme_service.AppThemeMode>(
      valueListenable: themeProvider,
      builder: (context, themeMode, _) {
        ThemeData theme;
        ThemeData darkTheme;

        if (themeMode == theme_service.AppThemeMode.system) {
          theme = AppTheme.lightTheme;
          darkTheme = AppTheme.darkTheme;
        } else if (themeMode == theme_service.AppThemeMode.dark) {
          theme = AppTheme.darkTheme;
          darkTheme = AppTheme.darkTheme;
        } else {
          theme = AppTheme.lightTheme;
          darkTheme = AppTheme.lightTheme;
        }

        return MaterialApp(
          title: 'BFT Calculator',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode == theme_service.AppThemeMode.system
              ? ThemeMode.system
              : (themeMode == theme_service.AppThemeMode.dark ? ThemeMode.dark : ThemeMode.light),
          home: const BftInputPage(),
        );
      },
    );
  }
}
