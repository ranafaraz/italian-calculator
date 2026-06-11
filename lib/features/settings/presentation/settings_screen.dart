import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/calc_colors.dart';
import '../../../shared/widgets/section_card.dart';
import '../application/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmClearData(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearDataConfirmTitle),
        content: Text(l10n.clearDataConfirmBody),
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
    if (confirmed != true) {
      return;
    }
    await ref.read(settingsControllerProvider.notifier).clearLocalData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.localDataCleared)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    final labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: calc.textSecondary,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          l10n.settingsTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.sectionAppearance,
          icon: Icons.palette_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.theme, style: labelStyle),
              const SizedBox(height: 8),
              SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (selection) =>
                    controller.setThemeMode(selection.first),
              ),
              const SizedBox(height: 16),
              Text(l10n.language, style: labelStyle),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: 'it', label: Text(l10n.italian)),
                  ButtonSegment(value: 'en', label: Text(l10n.english)),
                ],
                selected: {settings.locale.languageCode},
                onSelectionChanged: (selection) =>
                    controller.setLocale(Locale(selection.first)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.sectionCalculation,
          icon: Icons.functions_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.decimalPrecision,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: calc.accentSoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${settings.decimalPrecision}',
                      style: TextStyle(
                        fontFamily: AppTheme.numberFont,
                        fontWeight: FontWeight.w700,
                        color: calc.accent,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: settings.decimalPrecision.toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: (value) =>
                    controller.setDecimalPrecision(value.round()),
              ),
              Text(
                l10n.decimalPrecisionHint,
                style: TextStyle(fontSize: 12, color: calc.textSecondary),
              ),
              const Divider(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.haptics),
                subtitle: Text(l10n.hapticsHint),
                value: settings.hapticsEnabled,
                onChanged: controller.setHapticsEnabled,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.sectionData,
          icon: Icons.shield_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline_rounded, size: 16, color: calc.accent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.privacyNote,
                      style:
                          TextStyle(fontSize: 13, color: calc.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: calc.danger,
                ),
                title: Text(
                  l10n.clearLocalData,
                  style: TextStyle(
                    color: calc.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(l10n.clearDataHint),
                onTap: () => _confirmClearData(context, ref),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.sectionAbout,
          icon: Icons.info_outline_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: AppTheme.uiFont,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'Calc',
                      style: TextStyle(color: calc.textPrimary),
                    ),
                    TextSpan(
                      text: 'Flow',
                      style: TextStyle(color: calc.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.aboutTagline,
                style: TextStyle(fontSize: 13, color: calc.textSecondary),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    l10n.version,
                    style: TextStyle(fontSize: 13, color: calc.textSecondary),
                  ),
                  const Spacer(),
                  const Text(
                    '1.0.0',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
