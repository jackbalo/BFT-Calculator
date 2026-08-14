import 'package:flutter/services.dart';
import 'package:bft_calculator/services/preferences_service.dart';

/// Service for handling haptic feedback
class HapticService {
  final PreferencesService preferencesService;

  HapticService({required this.preferencesService});

  /// Light haptic feedback
  Future<void> lightTap() async {
    if (!preferencesService.isHapticEnabled()) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Platform doesn't support haptics
    }
  }

  /// Medium haptic feedback
  Future<void> mediumTap() async {
    if (!preferencesService.isHapticEnabled()) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Platform doesn't support haptics
    }
  }

  /// Heavy haptic feedback
  Future<void> heavyTap() async {
    if (!preferencesService.isHapticEnabled()) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Platform doesn't support haptics
    }
  }

  /// Selection haptic feedback
  Future<void> selectionTap() async {
    if (!preferencesService.isHapticEnabled()) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Platform doesn't support haptics
    }
  }
}
