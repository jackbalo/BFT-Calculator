import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bft_calculator/constants/app_constants.dart';
import 'package:bft_calculator/models/bft_user_data.dart';
import 'package:bft_calculator/utils/bft_calculator_utils.dart';
import 'package:bft_calculator/widgets/percentage_row.dart';
import 'package:bft_calculator/screens/input_page.dart';
import 'package:bft_calculator/services/theme_provider.dart' as theme_service;
import 'package:bft_calculator/main.dart';

class _RunTimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    String formatted = digits;
    if (digits.length > 2) {
      formatted = '${digits.substring(0, 2)}:${digits.substring(2)}';
    }

    if (formatted.length > 5) {
      formatted = formatted.substring(0, 5);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Fourth screen: Calculate BFT percentage
class BftCalculatorPage extends StatefulWidget {
  final BftUserData userData;

  const BftCalculatorPage({
    super.key,
    required this.userData,
  });

  @override
  State<BftCalculatorPage> createState() => _BftCalculatorPageState();
}

class _BftCalculatorPageState extends State<BftCalculatorPage> {
  final _pushupsController = TextEditingController();
  final _situpsController = TextEditingController();
  final _runningMinutesController = TextEditingController();
  String? _errorMessage;
  bool _showResults = false;

  late double _pushupsPercentage;
  late double _situpsPercentage;
  late double _runningPercentage;
  late double _averagePercentage;

  @override
  void dispose() {
    _pushupsController.dispose();
    _situpsController.dispose();
    _runningMinutesController.dispose();
    super.dispose();
  }

  void _calculatePercentages() async {
    setState(() {
      _errorMessage = null;
      _showResults = false;
    });

    final pushupsText = _pushupsController.text.trim();
    final situpsText = _situpsController.text.trim();
    final runningText = _runningMinutesController.text.trim();

    // Validate inputs
    final validationError = BftCalculatorUtils.validateCalculatorInputs(
      pushupsText,
      situpsText,
      runningText,
    );
    if (validationError != null) {
      setState(() {
        _errorMessage = validationError;
      });
      return;
    }

    final pushups = int.parse(pushupsText);
    final situps = int.parse(situpsText);
    final runningMinutes = BftCalculatorUtils.parseRunTimeToMinutes(runningText);

    // Calculate percentages
    _pushupsPercentage = BftCalculatorUtils.calculatePushupsPercentage(
      pushups,
      widget.userData.pushupsMark,
    );
    _situpsPercentage = BftCalculatorUtils.calculateSitupsPercentage(
      situps,
      widget.userData.situpsMark,
    );
    _runningPercentage = BftCalculatorUtils.calculateRunningPercentage(
      runningMinutes,
      widget.userData.runTimeMark,
    );

    _averagePercentage = BftCalculatorUtils.calculateAveragePercentage(
      _pushupsPercentage,
      _situpsPercentage,
      _runningPercentage,
    );

    // Haptic feedback for successful calculation
    await hapticService.mediumTap();

    setState(() {
      _showResults = true;
    });
  }

  void _clearForm() async {
    await hapticService.lightTap();
    setState(() {
      _pushupsController.clear();
      _situpsController.clear();
      _runningMinutesController.clear();
      _errorMessage = null;
      _showResults = false;
    });
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
        title: const Text(AppStrings.calculatorPageTitle),
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
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/t3.jpg'),
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
                              borderRadius:
                                  BorderRadius.circular(AppRadius.large),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.fitness_center, color: primaryColor),
                                const SizedBox(width: AppSpacing.medium),
                                Expanded(
                                  child: Text(
                                    AppStrings.activityResultsInfo,
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
                          TextField(
                            controller: _pushupsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: AppStrings.pushupsLabel,
                              hintText: AppStrings.pushupsHint,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.large),
                          TextField(
                            controller: _situpsController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: AppStrings.situpsLabel,
                              hintText: AppStrings.situpsHint,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.large),
                          TextField(
                            controller: _runningMinutesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_RunTimeInputFormatter()],
                            decoration: const InputDecoration(
                              labelText: AppStrings.runningLabel,
                              hintText: AppStrings.runningHint,
                            ),
                            onSubmitted: (_) {
                              _calculatePercentages();
                            },
                          ),
                          const SizedBox(height: AppSpacing.xLarge),
                          FilledButton.icon(
                            onPressed: () async {
                              await hapticService.mediumTap();
                              _calculatePercentages();
                            },
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text(AppStrings.calculateButton),
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
                            onPressed: _clearForm,
                            icon: const Icon(Icons.clear_all_rounded),
                            label: const Text(AppStrings.clearButton),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.large,
                              ),
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
                                borderRadius:
                                    BorderRadius.circular(AppRadius.medium),
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
                          if (_showResults) ...[
                            const SizedBox(height: AppSpacing.xxLarge),
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.extraLarge,
                                ),
                                border: Border.all(
                                  color: colorScheme.primary.withValues(alpha: 0.3),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.assessment_outlined,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: AppSpacing.small),
                                      Text(
                                        AppStrings.yourResults,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.medium),
                                  PercentageRow(
                                    label: 'Push-ups',
                                    percentage: _pushupsPercentage,
                                  ),
                                  PercentageRow(
                                    label: 'Sit-ups',
                                    percentage: _situpsPercentage,
                                  ),
                                  PercentageRow(
                                    label: 'Running',
                                    percentage: _runningPercentage,
                                  ),
                                  const SizedBox(height: AppSpacing.medium),
                                  Container(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.medium,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3F2FD),
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.medium,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          AppStrings.average,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${_averagePercentage.toStringAsFixed(2)}%',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  FilledButton.icon(
                    onPressed: () {
                      hapticService.heavyTap();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BftInputPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home_rounded),
                    label: const Text(AppStrings.backToStart),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: AppSpacing.xLarge,
                      ),
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.large),
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
