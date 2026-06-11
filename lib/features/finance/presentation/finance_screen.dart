import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/calc_colors.dart';
import '../../../core/formatting/app_number_format.dart';
import '../../../shared/widgets/result_value_row.dart';
import '../../../shared/widgets/section_card.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/finance_calculator.dart';

/// VAT (IVA) and discount calculators — the everyday Italian money tools.
class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  static const _finance = FinanceCalculator();
  static const _vatRates = [4, 5, 10, 22];
  static const _quickDiscounts = [10, 20, 30, 50];

  final _amountController = TextEditingController();
  final _customRateController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();

  /// false → add VAT (net → gross), true → remove VAT (gross → net).
  var _removeVat = false;

  /// One of [_vatRates], or null when the custom-rate field is active.
  int? _selectedRate = 22;

  @override
  void dispose() {
    _amountController.dispose();
    _customRateController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  VatCalculation? _computeVat() {
    final amount = AppNumberFormat.tryParse(_amountController.text);
    final rate = _selectedRate?.toDouble() ??
        AppNumberFormat.tryParse(_customRateController.text);
    if (amount == null || rate == null) {
      return null;
    }
    try {
      return _removeVat
          ? _finance.grossToNet(amount, rate)
          : _finance.netToGross(amount, rate);
    } on ArgumentError {
      return null;
    }
  }

  DiscountCalculation? _computeDiscount() {
    final price = AppNumberFormat.tryParse(_priceController.text);
    final rate = AppNumberFormat.tryParse(_discountController.text);
    if (price == null || rate == null) {
      return null;
    }
    try {
      return _finance.discount(price, rate);
    } on ArgumentError {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calc = CalcColors.of(context);
    final locale =
        ref.watch(settingsControllerProvider).locale.languageCode;

    final vat = _computeVat();
    final discount = _computeDiscount();

    String money(double? value) =>
        value == null ? '' : AppNumberFormat.currency(value, locale: locale);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text(
          l10n.financeTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: l10n.vatCalculator,
          icon: Icons.receipt_long_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: false, label: Text(l10n.addVat)),
                  ButtonSegment(value: true, label: Text(l10n.removeVat)),
                ],
                selected: {_removeVat},
                showSelectedIcon: false,
                expandedInsets: EdgeInsets.zero,
                onSelectionChanged: (selection) {
                  setState(() => _removeVat = selection.first);
                },
              ),
              const SizedBox(height: 16),
              _AmountField(
                controller: _amountController,
                label: _removeVat ? l10n.grossAmount : l10n.netAmount,
                suffix: '€',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.vatRate.toUpperCase(),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: calc.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final rate in _vatRates)
                    _RateChip(
                      label: '$rate%',
                      selected: _selectedRate == rate,
                      onSelected: () => setState(() => _selectedRate = rate),
                    ),
                  _RateChip(
                    label: l10n.customRate,
                    selected: _selectedRate == null,
                    onSelected: () => setState(() => _selectedRate = null),
                  ),
                ],
              ),
              if (_selectedRate == null) ...[
                const SizedBox(height: 12),
                _AmountField(
                  controller: _customRateController,
                  label: l10n.customRateLabel,
                  suffix: '%',
                  fontSize: 17,
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: 20),
              _ResultPanel(
                children: [
                  ResultValueRow(
                    label: l10n.netAmount,
                    value: money(vat?.net),
                    emphasized: _removeVat,
                  ),
                  ResultValueRow(
                    label: l10n.vatAmount,
                    value: money(vat?.vat),
                  ),
                  ResultValueRow(
                    label: l10n.grossAmount,
                    value: money(vat?.gross),
                    emphasized: !_removeVat,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: l10n.discountCalculator,
          icon: Icons.local_offer_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AmountField(
                controller: _priceController,
                label: l10n.originalPrice,
                suffix: '€',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              _AmountField(
                controller: _discountController,
                label: l10n.discountPercent,
                suffix: '%',
                fontSize: 17,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final percent in _quickDiscounts)
                    ActionChip(
                      label: Text('$percent%'),
                      onPressed: () {
                        _discountController.text = '$percent';
                        setState(() {});
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _ResultPanel(
                children: [
                  ResultValueRow(
                    label: l10n.youSave,
                    value: money(discount?.discountAmount),
                  ),
                  ResultValueRow(
                    label: l10n.finalPrice,
                    value: money(discount?.finalPrice),
                    emphasized: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 14,
              color: calc.textSecondary,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l10n.privacyNote,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: calc.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Themed numeric entry with the Space Grotesk display font.
class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.controller,
    required this.label,
    required this.onChanged,
    this.suffix,
    this.fontSize = 22,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;
  final String? suffix;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      style: TextStyle(
        fontFamily: AppTheme.numberFont,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: calc.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        suffixStyle: TextStyle(
          fontFamily: AppTheme.numberFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: calc.textSecondary,
        ),
      ),
    );
  }
}

class _RateChip extends StatelessWidget {
  const _RateChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onSelected: (_) => onSelected(),
    );
  }
}

/// Soft inset panel hosting the result rows of a card.
class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: calc.surfaceAlt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
