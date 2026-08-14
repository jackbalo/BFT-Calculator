import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences and saved data
class PreferencesService {
  static const String _lastGenderKey = 'last_gender';
  static const String _lastAgeKey = 'last_age';
  static const String _themeKey = 'theme_mode';
  static const String _hapticEnabledKey = 'haptic_enabled';

  late SharedPreferences _prefs;

  /// Initialize the preferences service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============= LAST INPUT MANAGEMENT =============

  /// Save the last used gender
  Future<void> saveLastGender(String gender) async {
    await _prefs.setString(_lastGenderKey, gender);
  }

  /// Get the last saved gender
  String? getLastGender() {
    return _prefs.getString(_lastGenderKey);
  }

  /// Save the last used age
  Future<void> saveLastAge(int age) async {
    await _prefs.setInt(_lastAgeKey, age);
  }

  /// Get the last saved age
  int? getLastAge() {
    return _prefs.getInt(_lastAgeKey);
  }

  /// Clear saved inputs
  Future<void> clearLastInput() async {
    await _prefs.remove(_lastGenderKey);
    await _prefs.remove(_lastAgeKey);
  }

  // ============= THEME MANAGEMENT =============

  /// Save theme mode (0 = light, 1 = dark, 2 = system)
  Future<void> saveThemeMode(int mode) async {
    await _prefs.setInt(_themeKey, mode);
  }

  /// Get saved theme mode (defaults to system = 2)
  int getThemeMode() {
    return _prefs.getInt(_themeKey) ?? 2; // 2 = system default
  }

  // ============= HAPTIC FEEDBACK MANAGEMENT =============

  /// Save haptic feedback preference
  Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool(_hapticEnabledKey, enabled);
  }

  /// Check if haptic feedback is enabled
  bool isHapticEnabled() {
    return _prefs.getBool(_hapticEnabledKey) ?? true; // Default: enabled
  }
}
