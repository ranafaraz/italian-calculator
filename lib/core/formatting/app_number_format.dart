import 'package:intl/intl.dart';

/// Locale-aware number formatting for the whole app.
///
/// Italian: `1.234,56` — English: `1,234.56`. Very large/small magnitudes
/// fall back to scientific notation so the display never overflows with
/// meaningless digits.
class AppNumberFormat {
  AppNumberFormat._();

  static const _sciUpperBound = 1e15;
  static const _sciLowerBound = 1e-9;

  /// Formats [value] with thousands grouping and up to [maxDecimals]
  /// fraction digits (trailing zeros trimmed).
  static String format(
    double value, {
    required String locale,
    int maxDecimals = 6,
  }) {
    if (value.isNaN || value.isInfinite) {
      return '';
    }
    // Normalize negative zero.
    if (value == 0) {
      value = 0;
    }
    final magnitude = value.abs();
    if (magnitude != 0 &&
        (magnitude >= _sciUpperBound || magnitude < _sciLowerBound)) {
      return _scientific(value, locale: locale);
    }

    final pattern = StringBuffer('#,##0');
    if (maxDecimals > 0) {
      pattern.write('.');
      pattern.write('#' * maxDecimals);
    }
    return NumberFormat(pattern.toString(), locale).format(value);
  }

  /// Formats a euro amount, e.g. `1.234,56 €` (it) / `€1,234.56` (en).
  static String currency(double value, {required String locale}) {
    if (value.isNaN || value.isInfinite) {
      return '';
    }
    if (value == 0) {
      value = 0;
    }
    return NumberFormat.currency(
      locale: locale,
      symbol: '€',
      decimalDigits: 2,
    ).format(value);
  }

  /// Like [format] but without thousands grouping — safe to re-insert into
  /// a calculator expression (e.g. continuing a calculation with Ans).
  static String plain(
    double value, {
    required String locale,
    int maxDecimals = 10,
  }) {
    if (value.isNaN || value.isInfinite) {
      return '';
    }
    if (value == 0) {
      value = 0;
    }
    final magnitude = value.abs();
    if (magnitude != 0 &&
        (magnitude >= _sciUpperBound || magnitude < _sciLowerBound)) {
      return _scientific(value, locale: locale);
    }
    final pattern = StringBuffer('0');
    if (maxDecimals > 0) {
      pattern.write('.');
      pattern.write('#' * maxDecimals);
    }
    return NumberFormat(pattern.toString(), locale).format(value);
  }

  /// The decimal separator glyph for [locale] (',' for it, '.' for en).
  static String decimalSeparator(String locale) =>
      NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP;

  /// Parses user input accepting both ',' and '.' as the decimal separator.
  /// Grouping separators are not expected (plain input fields).
  static double? tryParse(String text) {
    final normalized = text.trim().replaceAll(',', '.').replaceAll('−', '-');
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  static String _scientific(double value, {required String locale}) {
    final exponential = value.toStringAsExponential(6);
    final parts = exponential.split('e');
    var mantissa = parts[0];
    // Trim trailing zeros of the mantissa.
    if (mantissa.contains('.')) {
      mantissa = mantissa
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
    }
    final separator = decimalSeparator(locale);
    mantissa = mantissa.replaceAll('.', separator);
    final exponent = int.parse(parts[1]);
    return '$mantissa×10^$exponent';
  }
}
