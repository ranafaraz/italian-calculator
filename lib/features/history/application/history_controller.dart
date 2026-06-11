import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import '../data/history_repository.dart';
import '../domain/history_entry.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return SharedPreferencesHistoryRepository(
      ref.watch(sharedPreferencesProvider));
});

final historyControllerProvider =
    StateNotifierProvider<HistoryController, List<HistoryEntry>>((ref) {
  return HistoryController(ref.watch(historyRepositoryProvider))..load();
});

class HistoryController extends StateNotifier<List<HistoryEntry>> {
  HistoryController(this._repository) : super(const []);

  final HistoryRepository _repository;

  Future<void> load() async {
    final entries = await _repository.load();
    state = _sort(entries);
  }

  Future<void> add(String expression, String result) async {
    final now = DateTime.now();
    final entry = HistoryEntry(
      id: '${now.microsecondsSinceEpoch}-${state.length}',
      expression: expression,
      result: result,
      createdAt: now,
    );
    state = _sort([entry, ...state]);
    await _repository.save(state);
  }

  Future<void> togglePinned(String id) async {
    state = _sort([
      for (final entry in state)
        entry.id == id ? entry.copyWith(isPinned: !entry.isPinned) : entry,
    ]);
    await _repository.save(state);
  }

  Future<void> delete(String id) async {
    state = state.where((entry) => entry.id != id).toList(growable: false);
    await _repository.save(state);
  }

  Future<void> restore(HistoryEntry entry) async {
    state = _sort([entry, ...state.where((e) => e.id != entry.id)]);
    await _repository.save(state);
  }

  Future<void> clear() async {
    state = const [];
    await _repository.clear();
  }

  List<HistoryEntry> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return state;
    }
    return state
        .where(
          (entry) =>
              entry.expression.toLowerCase().contains(normalized) ||
              entry.result.toLowerCase().contains(normalized),
        )
        .toList(growable: false);
  }

  List<HistoryEntry> _sort(List<HistoryEntry> entries) {
    final sorted = entries.toList();
    sorted.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });
    return List.unmodifiable(sorted);
  }
}
