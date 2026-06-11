import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/calc_colors.dart';
import '../../../core/formatting/app_number_format.dart';
import '../../../shared/widgets/section_card.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/unit_converter.dart';

/// Unit converter — bidirectional: editing either field converts into the
/// other one live, which is the key differentiator over a one-way form.
class ConverterScreen extends ConsumerStatefulWidget {
  const ConverterScreen({super.key});

  @override
  ConsumerState<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends ConsumerState<ConverterScreen> {
  static const _converter = UnitConverter();

  final _fromController = TextEditingController(text: '1');
  final _toController = TextEditingController();

  var _category = UnitCategory.length;
  late UnitDefinition _fromUnit;
  late UnitDefinition _toUnit;

  /// Guards against onChanged feedback loops while writing programmatically.
  var _syncing = false;

  String get _locale =>
      ref.read(settingsControllerProvider).locale.languageCode;

  int get _precision =>
      ref.read(settingsControllerProvider).decimalPrecision;

  @override
  void initState() {
    super.initState();
    final units = _converter.unitsFor(_category);
    _fromUnit = units[0];
    _toUnit = units.length > 1 ? units[1] : units[0];
    _convert(intoTo: true);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  /// Converts the source field into the target one. Empty or unparsable
  /// input clears the target instead of showing a stale value.
  void _convert({required bool intoTo}) {
    final source = intoTo ? _fromController : _toController;
    final target = intoTo ? _toController : _fromController;
    final from = intoTo ? _fromUnit : _toUnit;
    final to = intoTo ? _toUnit : _fromUnit;

    final value = AppNumberFormat.tryParse(source.text);
    _syncing = true;
    if (value == null) {
      target.text = '';
    } else {
      try {
        final converted =
            _converter.convert(value: value, from: from, to: to);
        target.text = AppNumberFormat.plain(
          converted,
          locale: _locale,
          maxDecimals: _precision,
        );
      } on ArgumentError {
        target.text = '';
      }
    }
    _syncing = false;
  }

  void _onFromChanged(String _) {
    if (_syncing) {
      return;
    }
    _convert(intoTo: true);
    setState(() {});
  }

  void _onToChanged(String _) {
    if (_syncing) {
      return;
    }
    _convert(intoTo: false);
    setState(() {});
  }

  void _selectCategory(UnitCategory category) {
    if (category == _category) {
      return;
    }
    final units = _converter.unitsFor(category);
    setState(() {
      _category = category;
      _fromUnit = units[0];
      _toUnit = units.length > 1 ? units[1] : units[0];
    });
    _convert(intoTo: true);
  }

  void _swapUnits() {
    setState(() {
      final previous = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = previous;
    });
    _convert(intoTo: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final locale = settings.locale.languageCode;
    final precision = settings.decimalPrecision;
    final units = _converter.unitsFor(_category);

    String? equivalence;
    if (AppNumberFormat.tryParse(_fromController.text) != null) {
      try {
        final one = _converter.convert(
          value: 1,
          from: _fromUnit,
          to: _toUnit,
        );
        final formatted = AppNumberFormat.format(
          one,
          locale: locale,
          maxDecimals: precision,
        );
        if (formatted.isNotEmpty) {
          equivalence =
              '1 ${_fromUnit.symbol} = $formatted ${_toUnit.symbol}';
        }
      } on ArgumentError {
        equivalence = null;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          l10n.converterTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (final (index, category) in UnitCategory.values.indexed) ...[
                if (index > 0) const SizedBox(width: 8),
                _CategoryChip(
                  label: _categoryLabel(l10n, category),
                  selected: _category == category,
                  onSelected: () => _selectCategory(category),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UnitField(
                label: l10n.from,
                controller: _fromController,
                unit: _fromUnit,
                units: units,
                dropdownKey: ValueKey('from-${_category.name}-${_fromUnit.id}'),
                onValueChanged: _onFromChanged,
                onUnitChanged: (unit) {
                  setState(() => _fromUnit = unit);
                  _convert(intoTo: true);
                },
              ),
              const SizedBox(height: 6),
              Center(
                child: IconButton(
                  onPressed: _swapUnits,
                  tooltip: l10n.swapUnits,
                  icon: const Icon(Icons.swap_vert_rounded, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: calc.accentSoft,
                    foregroundColor: calc.accent,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _UnitField(
                label: l10n.to,
                controller: _toController,
                unit: _toUnit,
                units: units,
                dropdownKey: ValueKey('to-${_category.name}-${_toUnit.id}'),
                onValueChanged: _onToChanged,
                onUnitChanged: (unit) {
                  setState(() => _toUnit = unit);
                  _convert(intoTo: true);
                },
              ),
            ],
          ),
        ),
        if (equivalence != null) ...[
          const SizedBox(height: 14),
          Text(
            equivalence,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.numberFont,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: calc.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// One half of the converter: caption label, value field and unit selector.
class _UnitField extends StatelessWidget {
  const _UnitField({
    required this.label,
    required this.controller,
    required this.unit,
    required this.units,
    required this.dropdownKey,
    required this.onValueChanged,
    required this.onUnitChanged,
  });

  final String label;
  final TextEditingController controller;
  final UnitDefinition unit;
  final List<UnitDefinition> units;
  final Key dropdownKey;
  final ValueChanged<String> onValueChanged;
  final ValueChanged<UnitDefinition> onUnitChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: calc.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          onChanged: onValueChanged,
          style: TextStyle(
            fontFamily: AppTheme.numberFont,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: calc.textPrimary,
          ),
          decoration: const InputDecoration(hintText: '0'),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<UnitDefinition>(
          key: dropdownKey,
          initialValue: unit,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          dropdownColor: calc.surface,
          icon: Icon(Icons.expand_more_rounded, color: calc.textSecondary),
          style: TextStyle(
            fontFamily: AppTheme.uiFont,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: calc.textPrimary,
          ),
          items: [
            for (final option in units)
              DropdownMenuItem(
                value: option,
                child: Text(
                  '${_unitLabel(l10n, option.labelKey)} (${option.symbol})',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (selected) {
            if (selected != null) {
              onUnitChanged(selected);
            }
          },
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    final baseStyle = Theme.of(context).chipTheme.labelStyle;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      labelStyle: selected
          ? baseStyle?.copyWith(
              color: calc.accent,
              fontWeight: FontWeight.w700,
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onSelected: (_) => onSelected(),
    );
  }
}

String _categoryLabel(AppLocalizations l10n, UnitCategory category) {
  return switch (category) {
    UnitCategory.length => l10n.categoryLength,
    UnitCategory.mass => l10n.categoryMass,
    UnitCategory.temperature => l10n.categoryTemperature,
    UnitCategory.area => l10n.categoryArea,
    UnitCategory.volume => l10n.categoryVolume,
    UnitCategory.data => l10n.categoryData,
    UnitCategory.speed => l10n.categorySpeed,
    UnitCategory.time => l10n.categoryTime,
  };
}

String _unitLabel(AppLocalizations l10n, String labelKey) {
  return switch (labelKey) {
    'unitMeters' => l10n.unitMeters,
    'unitKilometers' => l10n.unitKilometers,
    'unitCentimeters' => l10n.unitCentimeters,
    'unitMillimeters' => l10n.unitMillimeters,
    'unitMiles' => l10n.unitMiles,
    'unitYards' => l10n.unitYards,
    'unitFeet' => l10n.unitFeet,
    'unitInches' => l10n.unitInches,
    'unitTonnes' => l10n.unitTonnes,
    'unitKilograms' => l10n.unitKilograms,
    'unitGrams' => l10n.unitGrams,
    'unitMilligrams' => l10n.unitMilligrams,
    'unitPounds' => l10n.unitPounds,
    'unitOunces' => l10n.unitOunces,
    'unitCelsius' => l10n.unitCelsius,
    'unitFahrenheit' => l10n.unitFahrenheit,
    'unitKelvin' => l10n.unitKelvin,
    'unitSquareMeters' => l10n.unitSquareMeters,
    'unitSquareKilometers' => l10n.unitSquareKilometers,
    'unitHectares' => l10n.unitHectares,
    'unitLiters' => l10n.unitLiters,
    'unitMilliliters' => l10n.unitMilliliters,
    'unitCubicMeters' => l10n.unitCubicMeters,
    'unitGallons' => l10n.unitGallons,
    'unitBytes' => l10n.unitBytes,
    'unitKilobytes' => l10n.unitKilobytes,
    'unitMegabytes' => l10n.unitMegabytes,
    'unitGigabytes' => l10n.unitGigabytes,
    'unitTerabytes' => l10n.unitTerabytes,
    'unitMetersPerSecond' => l10n.unitMetersPerSecond,
    'unitKilometersPerHour' => l10n.unitKilometersPerHour,
    'unitMilesPerHour' => l10n.unitMilesPerHour,
    'unitKnots' => l10n.unitKnots,
    'unitMilliseconds' => l10n.unitMilliseconds,
    'unitSeconds' => l10n.unitSeconds,
    'unitMinutes' => l10n.unitMinutes,
    'unitHours' => l10n.unitHours,
    'unitDays' => l10n.unitDays,
    'unitWeeks' => l10n.unitWeeks,
    'unitYears' => l10n.unitYears,
    _ => labelKey,
  };
}
