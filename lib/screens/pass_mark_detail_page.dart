import 'package:flutter/material.dart';
import 'package:bft_calculator/constants/app_constants.dart';
import 'package:bft_calculator/models/bft_user_data.dart';
import 'package:bft_calculator/screens/input_page.dart';
import 'package:bft_calculator/screens/check_pass_mark_page.dart';
import 'package:bft_calculator/screens/bft_calculator_page.dart';
import 'package:bft_calculator/services/theme_provider.dart' as theme_service;
import 'package:bft_calculator/main.dart';

/// Second screen: Options page (Check Pass Mark or Calculate Percentage)
class PassMarkDetailPage extends StatelessWidget {
  final BftUserData userData;

  const PassMarkDetailPage({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final secondaryColor = colorScheme.secondary;
    final tertiaryColor = colorScheme.tertiary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.optionsPageTitle),
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
            image: const AssetImage('assets/t1.jpg'),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                AppRadius.large,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.person, color: primaryColor),
                                const SizedBox(width: AppSpacing.medium),
                                Expanded(
                                  child: Text(
                                    '${userData.gender.toUpperCase()} | Age: ${userData.age}',
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
                          const SizedBox(height: AppSpacing.xxLarge),
                          Text(
                            AppStrings.whatToDo,
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                          ),
                          const SizedBox(height: AppSpacing.large),
                          FilledButton.icon(
                            onPressed: () {
                              hapticService.mediumTap();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckPassMarkPage(userData: userData),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text(
                              AppStrings.checkPassMarkButton,
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: AppSpacing.xLarge,
                              ),
                              minimumSize: const Size.fromHeight(56),
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.large),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                            ),
                            child: Text(
                              AppStrings.checkMarkDescription,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.large),
                          FilledButton.icon(
                            onPressed: () {
                              hapticService.mediumTap();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BftCalculatorPage(userData: userData),
                                ),
                              );
                            },
                            icon: const Icon(Icons.calculate_outlined),
                            label: const Text(
                              AppStrings.calculatePercentageButton,
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18.0,
                                horizontal: AppSpacing.xLarge,
                              ),
                              minimumSize: const Size.fromHeight(56),
                              backgroundColor: tertiaryColor,
                              foregroundColor: isDarkMode ? Colors.white : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.large),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.medium,
                            ),
                            child: Text(
                              AppStrings.calculateDescription,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
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
                      backgroundColor: secondaryColor,
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
