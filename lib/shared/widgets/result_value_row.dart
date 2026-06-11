import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../app/theme/app_theme.dart';
import '../../app/theme/calc_colors.dart';

/// Label + numeric value row with tap-to-copy, used in finance/converter
/// result panels. [emphasized] renders the value in the accent color and a
/// larger size (use for the main result of a card).
class ResultValueRow extends StatelessWidget {
  const ResultValueRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
    this.copyable = true,
  });

  final String label;
  final String value;
  final bool emphasized;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    final l10n = AppLocalizations.of(context);

    final valueText = Text(
      value.isEmpty ? '—' : value,
      textAlign: TextAlign.end,
      style: TextStyle(
        fontFamily: AppTheme.numberFont,
        fontSize: emphasized ? 24 : 17,
        fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
        color: emphasized ? calc.accent : calc.textPrimary,
        letterSpacing: -0.3,
      ),
    );

    return InkWell(
      onTap: copyable && value.isNotEmpty
          ? () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(l10n.copied)));
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: calc.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: valueText)),
          ],
        ),
      ),
    );
  }
}
