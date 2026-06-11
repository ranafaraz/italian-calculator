import 'package:calcflow/core/formatting/app_number_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNumberFormat.format', () {
    test('groups thousands per locale', () {
      expect(
        AppNumberFormat.format(1234567.891, locale: 'it', maxDecimals: 2),
        '1.234.567,89',
      );
      expect(
        AppNumberFormat.format(1234567.891, locale: 'en', maxDecimals: 2),
        '1,234,567.89',
      );
    });

    test('trims trailing zeros', () {
      expect(AppNumberFormat.format(2.5, locale: 'en', maxDecimals: 6), '2.5');
      expect(AppNumberFormat.format(4, locale: 'en', maxDecimals: 6), '4');
    });

    test('keeps the sign of small negatives (the -0.5 bug)', () {
      expect(
        AppNumberFormat.format(-0.5, locale: 'it', maxDecimals: 2),
        '-0,5',
      );
    });

    test('normalizes negative zero', () {
      expect(AppNumberFormat.format(-0.0, locale: 'en', maxDecimals: 2), '0');
    });

    test('falls back to scientific notation for extremes', () {
      expect(
        AppNumberFormat.format(1e16, locale: 'en', maxDecimals: 6),
        '1×10^16',
      );
      expect(
        AppNumberFormat.format(0.0000000001, locale: 'en', maxDecimals: 6),
        '1×10^-10',
      );
    });
  });

  group('AppNumberFormat.plain', () {
    test('no grouping, locale decimal separator', () {
      expect(
        AppNumberFormat.plain(1234.5, locale: 'it', maxDecimals: 6),
        '1234,5',
      );
      expect(
        AppNumberFormat.plain(1234.5, locale: 'en', maxDecimals: 6),
        '1234.5',
      );
    });
  });

  group('AppNumberFormat.currency', () {
    test('formats euro amounts', () {
      final it = AppNumberFormat.currency(1234.5, locale: 'it');
      expect(it, contains('€'));
      expect(it, contains('1.234,50'));

      final en = AppNumberFormat.currency(1234.5, locale: 'en');
      expect(en, contains('€'));
      expect(en, contains('1,234.50'));
    });
  });

  group('AppNumberFormat parsing and separators', () {
    test('decimalSeparator per locale', () {
      expect(AppNumberFormat.decimalSeparator('it'), ',');
      expect(AppNumberFormat.decimalSeparator('en'), '.');
    });

    test('tryParse accepts both separators and display minus', () {
      expect(AppNumberFormat.tryParse('1,5'), 1.5);
      expect(AppNumberFormat.tryParse('1.5'), 1.5);
      expect(AppNumberFormat.tryParse('−2'), -2);
      expect(AppNumberFormat.tryParse('abc'), isNull);
      expect(AppNumberFormat.tryParse(''), isNull);
    });
  });
}
