import 'package:flutter/material.dart';
import 'package:bft_calculator/constants/app_constants.dart';
import 'package:bft_calculator/utils/bft_calculator_utils.dart';
import 'package:bft_calculator/screens/pass_mark_detail_page.dart';
import 'package:bft_calculator/screens/settings_page.dart';
import 'package:bft_calculator/services/theme_provider.dart' as theme_service;
import 'package:bft_calculator/main.dart';

/// First screen: User input for gender and age
class BftInputPage extends StatefulWidget {
  const BftInputPage({super.key});

  @override
  State<BftInputPage> createState() => _BftInputPageState();
}

class _BftInputPageState extends State<BftInputPage> {
  final _ageController = TextEditingController();
  String? _selectedGender;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLastInput();
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  /// Load last saved inputs
  void _loadLastInput() {
    final lastGender = preferencesService.getLastGender();
    final lastAge = preferencesService.getLastAge();

    setState(() {
      _selectedGender = lastGender;
      if (lastAge != null) {
        _ageController.text = lastAge.toString();
      }
    });
  }

  void _clearForm() {
    setState(() {
      _ageController.clear();
      _selectedGender = null;
      _errorMessage = null;
    });
  }

  void _proceedToOptions() async {
    setState(() {
      _errorMessage = null;
    });

    final ageText = _ageController.text.trim();
    final gender = _selectedGender;

    if (gender == null || gender.isEmpty) {
      setState(() {
        _errorMessage = AppStrings.selectGenderError;
      });
      return;
    }

    if (ageText.isEmpty) {
      setState(() {
        _errorMessage = AppStrings.enterAgeError;
      });
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 18 || age > 60) {
      setState(() {
        _errorMessage = AppStrings.invalidAgeError;
      });
      return;
    }

    final standardsEntry = BftCalculatorUtils.findStandardForAge(age, gender);
    if (standardsEntry == null) {
      setState(() {
        _errorMessage = AppStrings.noStandardError;
      });
      return;
    }

    // Save last inputs
    await preferencesService.saveLastGender(gender);
    await preferencesService.saveLastAge(age);

    // Haptic feedback
    await hapticService.mediumTap();

    final userData = BftCalculatorUtils.createUserData(age, gender, standardsEntry);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassMarkDetailPage(userData: userData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(
            'assets/gaf3.jpg',
            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: 56,
        title: const Text(AppStrings.appTitle),
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
              hapticService.lightTap();
              final currentTheme = themeProvider.value;
              final newTheme = currentTheme == theme_service.AppThemeMode.dark
                  ? theme_service.AppThemeMode.light
                  : theme_service.AppThemeMode.dark;
              await themeProvider.setThemeMode(newTheme);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              hapticService.lightTap();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    themeProvider: themeProvider,
                    preferencesService: preferencesService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/t5.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.55),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xLarge,
              60,
              AppSpacing.xLarge,
              32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.medium),
                  const SizedBox(height: AppSpacing.xxLarge),
                  Card(
                    elevation: 0,
                    color: surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.rounded),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xLarge),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(AppRadius.large),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.fitness_center, color: primaryColor),
                                const SizedBox(width: AppSpacing.medium),
                                Expanded(
                                  child: Text(
                                    AppStrings.enterDetailsInfo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xLarge),
                          DropdownButtonFormField<String>(
                            key: const Key('genderField'),
                            decoration: const InputDecoration(
                              labelText: AppStrings.genderLabel,
                            ),
                            initialValue: _selectedGender,
                            items: const [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text(AppStrings.maleOption),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text(AppStrings.femaleOption),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                          ),
                          const SizedBox(height: AppSpacing.large),
                          TextField(
                            key: const Key('ageField'),
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: AppStrings.ageLabel,
                              hintText: AppStrings.ageHint,
                            ),
                            onSubmitted: (_) {
                              _proceedToOptions();
                            },
                          ),
                          const SizedBox(height: AppSpacing.xLarge),
                          FilledButton.icon(
                            onPressed: () async {
                              await hapticService.mediumTap();
                              _proceedToOptions();
                            },
                            icon: const Icon(Icons.arrow_forward_rounded),
                            label: const Text(AppStrings.proceedButton),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: AppSpacing.xLarge,
                              ),
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.large),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await hapticService.lightTap();
                              _clearForm();
                            },
                            icon: const Icon(Icons.clear_all_rounded),
                            label: const Text(AppStrings.clearButton),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: AppSpacing.xLarge,
                              ),
                              minimumSize: const Size.fromHeight(56),
                              side: BorderSide(color: colorScheme.error),
                              foregroundColor: colorScheme.error,
                              backgroundColor: colorScheme.errorContainer.withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.large),
                              ),
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: AppSpacing.large),
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.medium),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.medium,
                                ),
                                border: Border.all(color: colorScheme.error.withValues(alpha: 0.5)),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        ),
      );
  }
}
