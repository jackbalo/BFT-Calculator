import 'package:bft_calculator/models/bft_user_data.dart';
import 'package:bft_calculator/constants/bft_standards.dart';

/// Utility class for BFT calculations and validations
class BftCalculatorUtils {
  /// Find BFT standards for a given age and gender
  static List<dynamic>? findStandardForAge(int age, String gender) {
    final standards = gender == 'male'
        ? BftStandards.maleStandards
        : BftStandards.femaleStandards;

    try {
      final entry = standards.firstWhere(
        (item) => age >= item[0] && age <= item[1],
        orElse: () => const [],
      );
      return entry.isEmpty ? null : entry;
    } catch (e) {
      return null;
    }
  }

  /// Create BftUserData from age, gender, and standards entry
  static BftUserData createUserData(
    int age,
    String gender,
    List<dynamic> standardsEntry,
  ) {
    return BftUserData(
      age: age,
      gender: gender,
      ageCategory: '${standardsEntry[0]}-${standardsEntry[1]}',
      pushupsMark: standardsEntry[2] as int,
      situpsMark: standardsEntry[3] as int,
      runTimeMark: standardsEntry[4] as String,
    );
  }

  /// Parse run time (MM:SS format) to total seconds
  static int parseRunTimeToSeconds(String runTimeStr) {
    final parts = runTimeStr.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = parts.length > 1 && parts[1].isNotEmpty
        ? int.parse(parts[1])
        : 0;
    return minutes * 60 + seconds;
  }

  /// Parse run time input (MM:SS) to decimal minutes
  static double parseRunTimeToMinutes(String runTimeStr) {
    final parts = runTimeStr.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = parts.length > 1 && parts[1].isNotEmpty
        ? int.parse(parts[1])
        : 0;
    return minutes + (seconds / 60.0);
  }

  /// Calculate push-ups percentage
  static double calculatePushupsPercentage(
    int userScore,
    int passmarkScore,
  ) {
    double percentage = 60.0 + (userScore - passmarkScore).toDouble();
    return _capPercentage(percentage);
  }

  /// Calculate sit-ups percentage
  static double calculateSitupsPercentage(
    int userScore,
    int passmarkScore,
  ) {
    double percentage = 60.0 + (userScore - passmarkScore).toDouble();
    return _capPercentage(percentage);
  }

  /// Calculate running percentage
  static double calculateRunningPercentage(
    double userTimeMinutes,
    String passmarkTimeStr,
  ) {
    final passmarkTotalSeconds = parseRunTimeToSeconds(passmarkTimeStr);
    final userTimeSeconds = userTimeMinutes * 60;
    final secondsDifference = passmarkTotalSeconds - userTimeSeconds;
    double percentage = 60.0 + (secondsDifference / 60) * 10.0;
    return _capPercentage(percentage);
  }

  /// Calculate average percentage from three components
  static double calculateAveragePercentage(
    double pushupsPercentage,
    double situpsPercentage,
    double runningPercentage,
  ) {
    return (pushupsPercentage + situpsPercentage + runningPercentage) / 3;
  }

  /// Cap percentage between 0 and 100
  static double _capPercentage(double percentage) {
    if (percentage > 100.0) return 100.0;
    if (percentage < 0.0) return 0.0;
    return percentage;
  }

  /// Validate age input
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age.';
    }
    final age = int.tryParse(value);
    if (age == null || age < 18 || age > 56) {
      return 'Age must be between 18 and 56.';
    }
    return null;
  }

  /// Validate all input fields for calculator
  static String? validateCalculatorInputs(
    String pushupsText,
    String situpsText,
    String runningText,
  ) {
    if (pushupsText.isEmpty || situpsText.isEmpty || runningText.isEmpty) {
      return 'Please fill in all fields.';
    }

    final pushups = int.tryParse(pushupsText);
    final situps = int.tryParse(situpsText);

    final parts = runningText.split(':');
    if (parts.isEmpty || parts[0].isEmpty) {
      return 'Please enter running time as MM:SS.';
    }

    final minutes = int.tryParse(parts[0]);
    final seconds = parts.length > 1 && parts[1].isNotEmpty
        ? int.tryParse(parts[1])
        : 0;

    if (pushups == null || situps == null || minutes == null || seconds == null) {
      return 'Please enter valid numbers.';
    }

    if (seconds >= 60) {
      return 'Seconds must be between 00 and 59.';
    }

    return null;
  }
}
