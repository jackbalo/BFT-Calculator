import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bft_calculator/constants/app_constants.dart';

/// Application theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(
            color: Color(0xFF00897B),
            width: 1.8,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: const Color(0xFF00897B),                    // Ocean Teal
        onPrimary: Colors.white,                       // Text on primary
        primaryContainer: const Color(0xFF00695C),    // Dark teal container
        onPrimaryContainer: const Color(0xFFB2DFD8), // Light text on dark teal
        secondary: const Color(0xFF4A7BA7),           // Brighter navy for dark mode
        onSecondary: Colors.white,                     // Text on secondary
        secondaryContainer: const Color(0xFF1A3A52),  // Navy container
        onSecondaryContainer: const Color(0xFFB3D9FF), // Light text on navy
        tertiary: const Color(0xFF00BCD4),            // Cyan accent
        onTertiary: Colors.black,                      // Text on cyan
        tertiaryContainer: const Color(0xFF0097A7),   // Dark cyan
        onTertiaryContainer: const Color(0xFFB2EBF2), // Light text on dark cyan
        error: const Color(0xFFFF6B6B),               // Brighter red for errors
        onError: Colors.black,                         // Text on error
        errorContainer: const Color(0xFFC62828),      // Error container
        onErrorContainer: const Color(0xFFFFCDD2),    // Light text on error
        surface: const Color(0xFF1E1E1E),             // Dark surface
        onSurface: const Color(0xFFFAFAF8),           // Light text on surface
        surfaceContainerHighest: const Color(0xFF2A2A2A), // Lighter dark surface
        outlineVariant: const Color(0xFF3A3A3A),      // Outline/border
        outline: const Color(0xFF505050),             // Darker outline
      ),
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: const Color(0xFFEEEEEE),
        displayColor: const Color(0xFFEEEEEE),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(
            color: Color(0xFF00897B),
            width: 1.8,
          ),
        ),
        hintStyle: const TextStyle(color: Color(0xFF999999)),
      ),
    );
  }
}
