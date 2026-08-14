import 'package:flutter/material.dart';
import 'package:bft_calculator/constants/app_constants.dart';
import 'package:bft_calculator/models/bft_user_data.dart';
import 'package:bft_calculator/widgets/result_row.dart';
import 'package:bft_calculator/screens/input_page.dart';
import 'package:bft_calculator/services/theme_provider.dart' as theme_service;
import 'package:bft_calculator/main.dart';

/// Third screen: Display pass mark requirements
class CheckPassMarkPage extends StatelessWidget {
  final BftUserData userData;

  const CheckPassMarkPage({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.passMarkPageTitle),
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
            image: const AssetImage('assets/t2.jpg'),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: primaryColor,
                              ),
                              const SizedBox(width: AppSpacing.small),
                              Text(
                                AppStrings.passRequirement,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.medium),
                          ResultRow(
                            label: AppStrings.ageCategory,
                            value: userData.ageCategory,
                          ),
                          ResultRow(
                            label: AppStrings.pushups2Min,
                            value: '${userData.pushupsMark}',
                          ),
                          ResultRow(
                            label: AppStrings.situps2Min,
                            value: '${userData.situpsMark}',
                          ),
                          ResultRow(
                            label: AppStrings.run3_2km,
                            value: userData.runTimeMark,
                          ),
                          const SizedBox(height: AppSpacing.large),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                AppRadius.medium,
                              ),
                              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.medium),
                                Expanded(
                                  child: Text(
                                    AppStrings.passRequirementInfo,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  FilledButton.icon(
                    onPressed: () {
                      hapticService.lightTap();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text(AppStrings.backButton),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18.0,
                        horizontal: AppSpacing.xLarge,
                      ),
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
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
                      backgroundColor: colorScheme.secondary,
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
