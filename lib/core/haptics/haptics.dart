import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_controller.dart';

final hapticsProvider = Provider<Haptics>((ref) => Haptics(ref));

/// Centralized haptic feedback, gated by the user's settings toggle.
class Haptics {
  Haptics(this._ref);

  final Ref _ref;

  bool get _enabled =>
      _ref.read(settingsControllerProvider).hapticsEnabled;

  /// Standard keypad tap.
  void key() {
    if (_enabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Equals / commit actions.
  void confirm() {
    if (_enabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Errors (invalid expression on equals).
  void error() {
    if (_enabled) {
      HapticFeedback.heavyImpact();
    }
  }
}
