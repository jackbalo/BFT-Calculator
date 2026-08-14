import 'package:flutter/material.dart';

/// Application-wide color constants - GAF Branded
class AppColors {
  // Ocean/Teal Primary Colors
  static const Color primary = Color(0xFF00897B);           // Ocean Teal
  static const Color primaryDark = Color(0xFF00695C);       // Dark Teal
  static const Color accent = Color(0xFF00BCD4);            // Cyan Accent
  static const Color secondary = Color(0xFF1A3A52);         // Navy Blue
  static const Color success = Color(0xFF2D5016);           // Military Green
  static const Color warning = Color(0xFFFF9800);           // Orange
  static const Color error = Color(0xFFD32F2F);             // Error Red
  static const Color errorLight = Color(0xFFC62828);        // Light Error

  // Background and surface colors
  static const Color background = Color(0xFFF0FFFE);        // Light Teal Background
  static const Color surface = Color(0xFFFFFFFF);           // Pure White
  static const Color surfaceLight = Color(0xFFE0F7F6);      // Light Teal Surface

  // Border and divider colors
  static const Color border = Color(0xFFB2DFD8);            // Teal Border
  static const Color divider = Color(0xFFA8D5CF);           // Teal Divider

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);       // Deep Black
  static const Color textSecondary = Color(0xFF5A5A5A);     // Dark Gray
  static const Color textTertiary = Color(0xFF757575);      // Medium Gray

  // Input and form colors
  static const Color inputFill = Color(0xFFFFFFFF);         // White Input
  static const Color inputBorder = Color(0xFFB2DFD8);       // Teal Border
  static const Color inputFocusBorder = Color(0xFF00897B);  // Teal Focus

  // Info and helper colors
  static const Color infoBg = Color(0xFFE0F7F6);            // Light Teal Background
  static const Color infoBorder = Color(0xFF00897B);        // Teal Border
  static const Color infoText = Color(0xFF004D40);          // Dark Teal Text

  // Error helper colors
  static const Color errorBg = Color(0xFFFEEBEE);           // Light Red Background
  static const Color errorBgLight = Color(0xFFFFF5F5);      // Very Light Red

  // Progress indicator colors
  static const Color progressGreen = Color(0xFF2D5016);     // Military Green
  static const Color progressBlue = Color(0xFF00BCD4);      // Cyan
  static const Color progressOrange = Color(0xFFFF9800);    // Orange
  static const Color progressBackground = Color(0xFFB2DFD8); // Teal Gray
}

/// App radius constants
class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 14.0;
  static const double extraLarge = 18.0;
  static const double rounded = 24.0;
}

/// App spacing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 20.0;
  static const double xxLarge = 24.0;
  static const double xxxLarge = 32.0;
}

/// App string constants
class AppStrings {
  // App titles
  static const String appTitle = 'BFT Calculator';
  static const String appDescription = 'Know your Basic Fitness Test Requirement for GAF';

  // Screen titles
  static const String inputPageTitle = 'BFT Calculator';
  static const String optionsPageTitle = 'Options';
  static const String passMarkPageTitle = 'Pass Mark Requirements';
  static const String calculatorPageTitle = 'Calculate Percentage';

  // Form labels
  static const String genderLabel = 'Gender';
  static const String ageLabel = 'Age';
  static const String ageHint = '18 to 60';
  static const String pushupsLabel = 'Push-ups (count)';
  static const String pushupsHint = 'e.g., 45';
  static const String situpsLabel = 'Sit-ups (count)';
  static const String situpsHint = 'e.g., 55';
  static const String runningLabel = 'Running time (MM:SS format)';
  static const String runningHint = 'e.g., 15:30';

  // Button labels
  static const String proceedButton = 'Proceed';
  static const String clearButton = 'Clear';
  static const String backButton = 'Back';
  static const String calculateButton = 'Calculate';
  static const String checkPassMarkButton = 'Check BFT Pass Mark';
  static const String calculatePercentageButton = 'Calculate BFT Percentage';
  static const String backToStart = 'Back to Start';

  // Error messages
  static const String selectGenderError = 'Please select your gender.';
  static const String enterAgeError = 'Please enter your age.';
  static const String invalidAgeError = 'Age must be between 18 and 60.';
  static const String noStandardError = 'No matching standard was found.';
  static const String fillAllFieldsError = 'Please fill in all fields.';
  static const String invalidNumbersError = 'Please enter valid numbers.';

  // Info messages
  static const String enterDetailsInfo = 'Enter your gender and age';
  static const String activityResultsInfo = 'Enter your BFT activity results';
  static const String passRequirementInfo = 'These are the minimum scores needed to pass at 60% (passmark)';
  static const String checkMarkDescription = 'View the minimum scores required to pass (60% standard)';
  static const String calculateDescription = 'Calculate your performance score based on your actual results';

  // Question labels
  static const String whatToDo = 'What would you like to do?';
  static const String passRequirement = 'PASS REQUIREMENT';
  static const String yourResults = 'YOUR RESULTS';

  // Category and detail labels
  static const String ageCategory = 'Age category';
  static const String pushups2Min = 'Push-ups (2 min)';
  static const String situps2Min = 'Sit-ups (2 min)';
  static const String run3_2km = '3.2 km run time';
  static const String average = 'Average';

  // Gender options
  static const String maleOption = 'Male';
  static const String femaleOption = 'Female';
}
