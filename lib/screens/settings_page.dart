import 'package:flutter/material.dart';
import 'package:bft_calculator/constants/app_constants.dart';
import 'package:bft_calculator/services/preferences_service.dart';
import 'package:bft_calculator/services/theme_provider.dart' as theme_service;

/// Settings page for user preferences
class SettingsPage extends StatefulWidget {
  final theme_service.ThemeProvider themeProvider;
  final PreferencesService preferencesService;

  const SettingsPage({
    super.key,
    required this.themeProvider,
    required this.preferencesService,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late theme_service.AppThemeMode _selectedThemeMode;
  late bool _hapticEnabled;

  @override
  void initState() {
    super.initState();
    _selectedThemeMode = widget.themeProvider.value;
    _hapticEnabled = widget.preferencesService.isHapticEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final outlineColor = colorScheme.outlineVariant;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () async {
              final currentTheme = widget.themeProvider.value;
              final newTheme = currentTheme == theme_service.AppThemeMode.dark
                  ? theme_service.AppThemeMode.light
                  : theme_service.AppThemeMode.dark;
              await widget.themeProvider.setThemeMode(newTheme);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Settings
            Text(
              'Display',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
            ),
            const SizedBox(height: AppSpacing.large),
            
            // FIXED: Wrapped container's content with Material to fix ink splashes
            Material(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.large),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(color: outlineColor),
                ),
                child: RadioGroup<theme_service.AppThemeMode>(
                  groupValue: _selectedThemeMode,
                  onChanged: (theme_service.AppThemeMode? value) async {
                    if (value != null) {
                      setState(() {
                        _selectedThemeMode = value;
                      });
                      await widget.themeProvider.setThemeMode(value);
                    }
                  },
                  child: Column(
                    children: [
                      _buildThemeRadioTile(
                        'Light Mode',
                        theme_service.AppThemeMode.light,
                        Icons.light_mode_outlined,
                        primaryColor,
                      ),
                      Divider(
                        height: 0,
                        color: outlineColor,
                      ),
                      _buildThemeRadioTile(
                        'Dark Mode',
                        theme_service.AppThemeMode.dark,
                        Icons.dark_mode_outlined,
                        primaryColor,
                      ),
                      Divider(
                        height: 0,
                        color: outlineColor,
                      ),
                      _buildThemeRadioTile(
                        'System',
                        theme_service.AppThemeMode.system,
                        Icons.settings_brightness_outlined,
                        primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxLarge),

            // Haptic Feedback Settings
            Text(
              'Feedback',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
            ),
            const SizedBox(height: AppSpacing.large),
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: outlineColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xLarge,
                  vertical: AppSpacing.large,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.vibration,
                          color: primaryColor,
                        ),
                        const SizedBox(width: AppSpacing.large),
                        Text(
                          'Haptic Feedback',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Switch(
                      value: _hapticEnabled,
                      onChanged: (value) async {
                        setState(() {
                          _hapticEnabled = value;
                        });
                        await widget.preferencesService
                            .setHapticEnabled(value);
                      },
                      activeThumbColor: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxLarge),

            // Info Section
            Container(
              padding: const EdgeInsets.all(AppSpacing.large),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: outlineColor),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                  ),
                  const SizedBox(width: AppSpacing.large),
                  Expanded(
                    child: Text(
                      'Your preferences are automatically saved and applied when you restart the app.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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

  Widget _buildThemeRadioTile(
    String title,
    theme_service.AppThemeMode mode,
    IconData icon,
    Color primaryColor,
  ) {
    // FIXED: Wrapped the ListTile in Material to provide surface context for touch ripples
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: AppSpacing.large),
            Text(title),
          ],
        ),
        trailing: Radio<theme_service.AppThemeMode>(
          value: mode,
        ),
        onTap: () async {
          setState(() {
            _selectedThemeMode = mode;
          });
          await widget.themeProvider.setThemeMode(mode);
        },
      ),
    );
  }
}
