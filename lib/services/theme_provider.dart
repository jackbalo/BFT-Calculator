import 'package:flutter/material.dart';
import 'package:bft_calculator/services/preferences_service.dart';

/// Theme mode options
enum AppThemeMode { light, dark, system }

/// Provider for managing theme dynamically
class ThemeProvider extends ValueNotifier<AppThemeMode> {
  final PreferencesService preferencesService;

  ThemeProvider({required this.preferencesService})
      : super(AppThemeMode.system) {
    _loadThemeMode();
  }

  /// Load theme mode from preferences
  void _loadThemeMode() {
    final mode = preferencesService.getThemeMode();
    value = AppThemeMode.values[mode];
  }

  /// Change theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    value = mode;
    await preferencesService.saveThemeMode(mode.index);
  }

  /// Check if current theme should be dark
  bool isDarkMode(BuildContext context) {
    if (value == AppThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return value == AppThemeMode.dark;
  }
}
