import 'package:calcflow/features/history/application/history_controller.dart';
import 'package:calcflow/features/history/data/history_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'HistoryController persists, searches, pins, deletes, and clears entries',
      () async {
    final repository = InMemoryHistoryRepository();
    final controller = HistoryController(repository);

    await controller.load();
    await controller.add('2 + 2', '4');
    await controller.add('10 / 4', '2.5');

    expect(controller.state, hasLength(2));
    expect(controller.search('2.5').single.expression, '10 / 4');

    final firstId = controller.state.last.id;
    await controller.togglePinned(firstId);
    expect(controller.state.first.id, firstId);
    expect(controller.state.first.isPinned, isTrue);

    final restored = HistoryController(repository);
    await restored.load();
    expect(restored.state, hasLength(2));

    final deleted =
        restored.state.firstWhere((entry) => entry.id == firstId);
    await restored.delete(firstId);
    expect(restored.state, hasLength(1));

    await restored.restore(deleted);
    expect(restored.state, hasLength(2));
    expect(restored.state.first.id, firstId);

    await restored.clear();
    expect(restored.state, isEmpty);
  });
}
