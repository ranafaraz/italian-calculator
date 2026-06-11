import 'package:calcflow/features/finance/domain/finance_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = FinanceCalculator();

  group('FinanceCalculator', () {
    test('calculates IVA from net amount', () {
      expect(calculator.netToGross(100, 22).gross, 122);
      expect(calculator.netToGross(100, 22).vat, 22);
      expect(calculator.netToGross(100, 10).gross, 110);
      expect(calculator.netToGross(100, 4).gross, 104);
      expect(calculator.netToGross(200, 7.5).gross, 215);
      expect(calculator.netToGross(200, 7.5).vat, 15);
    });

    test('calculates IVA from gross amount', () {
      final twentyTwo = calculator.grossToNet(122, 22);
      expect(twentyTwo.net, closeTo(100, 0.000000001));
      expect(twentyTwo.vat, closeTo(22, 0.000000001));

      final ten = calculator.grossToNet(110, 10);
      expect(ten.net, closeTo(100, 0.000000001));
      expect(ten.vat, closeTo(10, 0.000000001));
    });

    test('calculates discounts', () {
      expect(calculator.discount(100, 20).finalPrice, 80);
      expect(calculator.discount(100, 20).discountAmount, 20);
      expect(calculator.discount(49.99, 10).finalPrice,
          closeTo(44.991, 0.000000001));
      expect(calculator.discount(100, 0).finalPrice, 100);
      expect(calculator.discount(100, 100).finalPrice, 0);
    });
  });
}
