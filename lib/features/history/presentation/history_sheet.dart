import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/calc_colors.dart';
import '../application/history_controller.dart';
import '../domain/history_entry.dart';

/// Calculation history, shown inside a modal [DraggableScrollableSheet].
///
/// The caller is responsible for presenting the sheet; this widget only
/// renders its content and wires the provided [scrollController] to the
/// inner list so the sheet can be dragged from the list itself.
class HistorySheet extends ConsumerStatefulWidget {
  const HistorySheet({
    super.key,
    required this.onReuse,
    this.scrollController,
  });

  /// Called with the tapped entry's expression so the calculator can reuse it.
  final ValueChanged<String> onReuse;

  final ScrollController? scrollController;

  @override
  ConsumerState<HistorySheet> createState() => _HistorySheetState();
}

class _HistorySheetState extends ConsumerState<HistorySheet> {
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmClear() async {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearHistoryConfirmTitle),
        content: Text(l10n.clearHistoryConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: calc.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(historyControllerProvider.notifier).clear();
    }
  }

  void _copyResult(HistoryEntry entry) {
    final l10n = AppLocalizations.of(context);
    Clipboard.setData(ClipboardData(text: entry.result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.copied)),
    );
  }

  void _deleteWithUndo(HistoryEntry entry) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(historyControllerProvider.notifier);
    controller.delete(entry.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.entryDeleted),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => controller.restore(entry),
        ),
      ),
    );
  }

  String _dayLabel(AppLocalizations l10n, String locale, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) {
      return l10n.today;
    }
    if (difference == 1) {
      return l10n.yesterday;
    }
    return DateFormat.yMMMMd(locale).format(date);
  }

  List<Widget> _buildGroupedTiles(
    AppLocalizations l10n,
    String locale,
    List<HistoryEntry> entries,
  ) {
    final pinned = entries.where((entry) => entry.isPinned);
    final unpinned = entries.where((entry) => !entry.isPinned);
    final tiles = <Widget>[];

    if (pinned.isNotEmpty) {
      tiles.add(_SectionHeader(label: l10n.pinned));
      for (final entry in pinned) {
        tiles.add(_buildTile(locale, entry));
      }
    }

    String? currentLabel;
    for (final entry in unpinned) {
      final label = _dayLabel(l10n, locale, entry.createdAt);
      if (label != currentLabel) {
        currentLabel = label;
        tiles.add(_SectionHeader(label: label));
      }
      tiles.add(_buildTile(locale, entry));
    }
    return tiles;
  }

  Widget _buildTile(String locale, HistoryEntry entry) {
    final calc = CalcColors.of(context);
    final controller = ref.read(historyControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Dismissible(
        key: ValueKey(entry.id),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: calc.dangerSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 18),
          child: Icon(Icons.delete_outline_rounded, color: calc.danger),
        ),
        onDismissed: (_) => _deleteWithUndo(entry),
        child: _HistoryTile(
          entry: entry,
          time: DateFormat.Hm(locale).format(entry.createdAt),
          onTap: () => widget.onReuse(entry.expression),
          onTogglePinned: () => controller.togglePinned(entry.id),
          onCopy: () => _copyResult(entry),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final history = ref.watch(historyControllerProvider);
    final filtered =
        ref.read(historyControllerProvider.notifier).search(_query);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: calc.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                l10n.history,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                tooltip: l10n.clearHistory,
                onPressed: history.isEmpty ? null : _confirmClear,
                icon: const Icon(Icons.delete_sweep_outlined),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: l10n.searchHistory,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        Expanded(
          child: history.isEmpty
              ? _EmptyState(
                  title: l10n.emptyHistoryTitle,
                  subtitle: l10n.emptyHistorySubtitle,
                )
              : filtered.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noSearchResults,
                        style: TextStyle(color: calc.textSecondary),
                      ),
                    )
                  : ListView(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      children: _buildGroupedTiles(l10n, locale, filtered),
                    ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: calc.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.entry,
    required this.time,
    required this.onTap,
    required this.onTogglePinned,
    required this.onCopy,
  });

  final HistoryEntry entry;
  final String time;
  final VoidCallback onTap;
  final VoidCallback onTogglePinned;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);

    return Material(
      color: calc.surfaceAlt,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.expression,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: calc.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '= ${entry.result}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTheme.numberFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: calc.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: calc.textSecondary,
                ),
              ),
              IconButton(
                tooltip: entry.isPinned ? l10n.unpin : l10n.pin,
                visualDensity: VisualDensity.compact,
                onPressed: onTogglePinned,
                icon: Icon(
                  entry.isPinned
                      ? Icons.push_pin_rounded
                      : Icons.push_pin_outlined,
                  size: 18,
                  color: entry.isPinned ? calc.accent : calc.textSecondary,
                ),
              ),
              IconButton(
                tooltip: l10n.copy,
                visualDensity: VisualDensity.compact,
                onPressed: onCopy,
                icon: Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: calc.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history_rounded, size: 48, color: calc.textSecondary),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: calc.textSecondary),
          ),
        ],
      ),
    );
  }
}
