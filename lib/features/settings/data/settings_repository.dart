import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/settings_state.dart';

class SettingsRepository {
  SettingsRepository(this._preferences);

  static const _localeKey = 'calcflow.settings.locale';
  static const _themeKey = 'calcflow.settings.theme';
  static const _precisionKey = 'calcflow.settings.precision';
  static const _hapticsKey = 'calcflow.settings.haptics';

  final SharedPreferences _preferences;

  SettingsState load() {
    final languageCode = _preferences.getString(_localeKey) ?? 'it';
    final themeName =
        _preferences.getString(_themeKey) ?? ThemeMode.system.name;
    final precision = _preferences.getInt(_precisionKey) ?? 6;
    final haptics = _preferences.getBool(_hapticsKey) ?? true;
    return SettingsState(
      locale: Locale(languageCode),
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == themeName,
        orElse: () => ThemeMode.system,
      ),
      decimalPrecision: precision.clamp(0, 10),
      hapticsEnabled: haptics,
    );
  }

  Future<void> save(SettingsState state) async {
    await _preferences.setString(_localeKey, state.locale.languageCode);
    await _preferences.setString(_themeKey, state.themeMode.name);
    await _preferences.setInt(_precisionKey, state.decimalPrecision);
    await _preferences.setBool(_hapticsKey, state.hapticsEnabled);
  }

  Future<void> clear() async {
    await _preferences.remove(_localeKey);
    await _preferences.remove(_themeKey);
    await _preferences.remove(_precisionKey);
    await _preferences.remove(_hapticsKey);
  }
}
