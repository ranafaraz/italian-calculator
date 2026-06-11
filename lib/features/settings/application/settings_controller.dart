import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import '../../history/application/history_controller.dart';
import '../data/settings_repository.dart';
import '../domain/settings_state.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(sharedPreferencesProvider));
});

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController(ref);
});

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._ref)
      : _repository = _ref.read(settingsRepositoryProvider),
        super(_ref.read(settingsRepositoryProvider).load());

  final Ref _ref;
  final SettingsRepository _repository;

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _repository.save(state);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _repository.save(state);
  }

  Future<void> setDecimalPrecision(int precision) async {
    state = state.copyWith(decimalPrecision: precision.clamp(0, 10));
    await _repository.save(state);
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    state = state.copyWith(hapticsEnabled: enabled);
    await _repository.save(state);
  }

  Future<void> clearLocalData() async {
    await _ref.read(historyControllerProvider.notifier).clear();
    await _repository.clear();
    state = const SettingsState();
  }
}
