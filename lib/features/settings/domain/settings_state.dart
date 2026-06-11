import 'package:flutter/material.dart';

class SettingsState {
  const SettingsState({
    this.locale = const Locale('it'),
    this.themeMode = ThemeMode.system,
    this.decimalPrecision = 6,
    this.hapticsEnabled = true,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final int decimalPrecision;
  final bool hapticsEnabled;

  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    int? decimalPrecision,
    bool? hapticsEnabled,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
