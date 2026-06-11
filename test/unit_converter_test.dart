import 'package:calcflow/features/converter/domain/unit_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = UnitConverter();

  UnitDefinition unit(String id) {
    return UnitConverter.units.firstWhere((item) => item.id == id);
  }

  group('UnitConverter', () {
    test('converts length', () {
      expect(
          converter.convert(value: 1, from: unit('km'), to: unit('m')), 1000);
      expect(converter.convert(value: 1, from: unit('m'), to: unit('cm')), 100);
    });

    test('converts mass', () {
      expect(
          converter.convert(value: 1, from: unit('kg'), to: unit('g')), 1000);
    });

    test('converts temperature', () {
      expect(converter.convert(value: 0, from: unit('c'), to: unit('f')), 32);
      expect(
          converter.convert(value: 100, from: unit('c'), to: unit('f')), 212);
    });

    test('converts binary data units', () {
      expect(
          converter.convert(value: 1, from: unit('gb'), to: unit('mb')), 1024);
    });

    test('converts speed', () {
      expect(
        converter.convert(value: 1, from: unit('mps'), to: unit('kph')),
        closeTo(3.6, 0.000000001),
      );
    });

    test('converts time', () {
      expect(converter.convert(value: 2, from: unit('h'), to: unit('min')),
          120);
      expect(converter.convert(value: 1, from: unit('d'), to: unit('h')), 24);
      expect(converter.convert(value: 1, from: unit('wk'), to: unit('d')), 7);
    });

    test('converts imperial length units', () {
      expect(
        converter.convert(value: 1, from: unit('in'), to: unit('cm')),
        closeTo(2.54, 0.000000001),
      );
      expect(
        converter.convert(value: 1, from: unit('yd'), to: unit('ft')),
        closeTo(3, 0.000000001),
      );
    });

    test('every category exposes at least two units', () {
      for (final category in UnitCategory.values) {
        expect(converter.unitsFor(category).length, greaterThanOrEqualTo(2),
            reason: category.name);
      }
    });
  });
}
