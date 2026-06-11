import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/history_entry.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntry>> load();

  Future<void> save(List<HistoryEntry> entries);

  Future<void> clear();
}

class SharedPreferencesHistoryRepository implements HistoryRepository {
  SharedPreferencesHistoryRepository(this._preferences);

  static const _key = 'calcflow.history.v1';

  final SharedPreferences _preferences;

  @override
  Future<List<HistoryEntry>> load() async {
    final encoded = _preferences.getString(_key);
    if (encoded == null || encoded.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(encoded) as List<dynamic>;
    return decoded
        .map((item) =>
            HistoryEntry.fromJson(Map<String, Object?>.from(item as Map)))
        .toList(growable: false);
  }

  @override
  Future<void> save(List<HistoryEntry> entries) async {
    final encoded = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await _preferences.setString(_key, encoded);
  }

  @override
  Future<void> clear() async {
    await _preferences.remove(_key);
  }
}

class InMemoryHistoryRepository implements HistoryRepository {
  List<HistoryEntry> _entries = [];

  @override
  Future<List<HistoryEntry>> load() async => List.unmodifiable(_entries);

  @override
  Future<void> save(List<HistoryEntry> entries) async {
    _entries = entries.toList(growable: false);
  }

  @override
  Future<void> clear() async {
    _entries = [];
  }
}
