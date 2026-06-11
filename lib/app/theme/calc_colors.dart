import 'package:flutter/material.dart';

/// Brand + calculator-specific design tokens.
///
/// CalcFlow brand: "Tricolore Premium" — neutral slate surfaces, emerald
/// primary (equals / results / selection), warm amber for operators and a
/// soft coral reserved for destructive actions. A quiet nod to the Italian
/// flag without being kitsch.
@immutable
class CalcColors extends ThemeExtension<CalcColors> {
  const CalcColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.accentSoft,
    required this.danger,
    required this.dangerSoft,
    required this.keyDigitBg,
    required this.keyDigitFg,
    required this.keyFnBg,
    required this.keyFnFg,
    required this.keyOpBg,
    required this.keyOpFg,
    required this.equalsGradStart,
    required this.equalsGradEnd,
    required this.equalsFg,
    required this.displayExpression,
    required this.displayResult,
    required this.displayPreview,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color accentSoft;
  final Color danger;
  final Color dangerSoft;
  final Color keyDigitBg;
  final Color keyDigitFg;
  final Color keyFnBg;
  final Color keyFnFg;
  final Color keyOpBg;
  final Color keyOpFg;
  final Color equalsGradStart;
  final Color equalsGradEnd;
  final Color equalsFg;
  final Color displayExpression;
  final Color displayResult;
  final Color displayPreview;
  final Color shadow;

  LinearGradient get equalsGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [equalsGradStart, equalsGradEnd],
      );

  static const light = CalcColors(
    background: Color(0xFFF4F6F8),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEDF1F5),
    cardBorder: Color(0xFFE4E9EF),
    textPrimary: Color(0xFF141A22),
    textSecondary: Color(0xFF5D6B7E),
    accent: Color(0xFF0C9F68),
    accentSoft: Color(0xFFDDF5EA),
    danger: Color(0xFFE5484D),
    dangerSoft: Color(0xFFFDE8E8),
    keyDigitBg: Color(0xFFFFFFFF),
    keyDigitFg: Color(0xFF141A22),
    keyFnBg: Color(0xFFE7ECF2),
    keyFnFg: Color(0xFF445162),
    keyOpBg: Color(0xFFFFF0DC),
    keyOpFg: Color(0xFFE0760B),
    equalsGradStart: Color(0xFF18BD7C),
    equalsGradEnd: Color(0xFF089563),
    equalsFg: Color(0xFFFFFFFF),
    displayExpression: Color(0xFF141A22),
    displayResult: Color(0xFF141A22),
    displayPreview: Color(0xFF8593A6),
    shadow: Color(0x14202B3A),
  );

  static const dark = CalcColors(
    background: Color(0xFF0B0E13),
    surface: Color(0xFF131822),
    surfaceAlt: Color(0xFF1B2230),
    cardBorder: Color(0xFF232C3C),
    textPrimary: Color(0xFFF2F5FA),
    textSecondary: Color(0xFF93A0B4),
    accent: Color(0xFF2BD98A),
    accentSoft: Color(0xFF11291E),
    danger: Color(0xFFFF6B6B),
    dangerSoft: Color(0xFF2E1718),
    keyDigitBg: Color(0xFF161D29),
    keyDigitFg: Color(0xFFF2F5FA),
    keyFnBg: Color(0xFF202A3A),
    keyFnFg: Color(0xFFB8C3D4),
    keyOpBg: Color(0xFF2B2013),
    keyOpFg: Color(0xFFFFAE52),
    equalsGradStart: Color(0xFF2BD98A),
    equalsGradEnd: Color(0xFF0F9D67),
    equalsFg: Color(0xFF04150D),
    displayExpression: Color(0xFFF2F5FA),
    displayResult: Color(0xFFF2F5FA),
    displayPreview: Color(0xFF7E8CA0),
    shadow: Color(0x66000000),
  );

  static CalcColors of(BuildContext context) =>
      Theme.of(context).extension<CalcColors>()!;

  @override
  CalcColors copyWith() => this;

  @override
  CalcColors lerp(ThemeExtension<CalcColors>? other, double t) {
    if (other is! CalcColors) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return CalcColors(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceAlt: mix(surfaceAlt, other.surfaceAlt),
      cardBorder: mix(cardBorder, other.cardBorder),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      accent: mix(accent, other.accent),
      accentSoft: mix(accentSoft, other.accentSoft),
      danger: mix(danger, other.danger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      keyDigitBg: mix(keyDigitBg, other.keyDigitBg),
      keyDigitFg: mix(keyDigitFg, other.keyDigitFg),
      keyFnBg: mix(keyFnBg, other.keyFnBg),
      keyFnFg: mix(keyFnFg, other.keyFnFg),
      keyOpBg: mix(keyOpBg, other.keyOpBg),
      keyOpFg: mix(keyOpFg, other.keyOpFg),
      equalsGradStart: mix(equalsGradStart, other.equalsGradStart),
      equalsGradEnd: mix(equalsGradEnd, other.equalsGradEnd),
      equalsFg: mix(equalsFg, other.equalsFg),
      displayExpression: mix(displayExpression, other.displayExpression),
      displayResult: mix(displayResult, other.displayResult),
      displayPreview: mix(displayPreview, other.displayPreview),
      shadow: mix(shadow, other.shadow),
    );
  }
}
