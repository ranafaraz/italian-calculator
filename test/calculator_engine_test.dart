import 'package:calcflow/features/calculator/domain/calculator_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = CalculatorEngine();

  double value(
    String expression, {
    AngleMode angleMode = AngleMode.degrees,
    double ans = 0,
  }) {
    final result =
        engine.evaluate(expression, angleMode: angleMode, ansValue: ans);
    expect(result.error, isNull, reason: 'expression: $expression');
    return result.value!;
  }

  group('CalculatorEngine basics', () {
    test('evaluates basic arithmetic', () {
      expect(value('2 + 2'), 4);
      expect(value('10 / 4'), 2.5);
      expect(value('0.1 + 0.2'), closeTo(0.3, 0.000000001));
    });

    test('respects operator precedence and parentheses', () {
      expect(value('2 + 3 * 4'), 14);
      expect(value('(2 + 3) * 4'), 20);
    });

    test('supports documented percentage behavior', () {
      expect(value('100 - 25%'), 75);
      expect(value('100 + 25%'), 125);
      expect(value('200 * 10%'), 20);
    });

    test('supports powers and scientific functions', () {
      expect(value('2 ^ 3'), 8);
      expect(value('sqrt(81)'), 9);
      expect(value('log(100)'), closeTo(2, 0.000000001));
      expect(value('ln(e)'), closeTo(1, 0.000000001));
      expect(value('sin(90)'), closeTo(1, 0.000000001));
      expect(value('cos(0)'), closeTo(1, 0.000000001));
      expect(value('tan(45)'), closeTo(1, 0.000000001));
    });

    test('supports radian mode', () {
      expect(value('sin(pi / 2)', angleMode: AngleMode.radians),
          closeTo(1, 0.000000001));
    });
  });

  group('CalculatorEngine display glyphs and locale input', () {
    test('parses × ÷ − and comma decimals', () {
      expect(value('7×8−3'), 53);
      expect(value('10÷4'), 2.5);
      expect(value('2,5+1'), 3.5);
      expect(value('−5+10'), 5);
    });

    test('parses √ π and ² glyphs', () {
      expect(value('√(16)'), 4);
      expect(value('π'), closeTo(3.14159265, 0.000001));
      expect(value('5²'), 25);
    });
  });

  group('CalculatorEngine advanced', () {
    test('implicit multiplication', () {
      expect(value('2(3+1)'), 8);
      expect(value('(2)(3)'), 6);
      expect(value('2π'), closeTo(6.2831853, 0.000001));
    });

    test('factorial', () {
      expect(value('5!'), 120);
      expect(value('0!'), 1);
      expect(value('3!+1'), 7);
      expect(engine.evaluate('2,5!').error, CalculationError.mathDomain);
      expect(engine.evaluate('(0−3)!').error, CalculationError.mathDomain);
    });

    test('inverse trigonometry honors angle mode', () {
      expect(value('asin(1)'), closeTo(90, 0.000001));
      expect(value('atan(1)'), closeTo(45, 0.000001));
      expect(value('acos(1)', angleMode: AngleMode.radians), 0);
    });

    test('abs and Ans', () {
      expect(value('abs(0−5)'), 5);
      expect(value('Ans+1', ans: 41), 42);
      expect(value('2Ans', ans: 10), 20);
    });

    test('unary minus binds looser than power', () {
      expect(value('−2^2'), -4);
      expect(value('2^−2'), 0.25);
      expect(value('(−2)^2'), 4);
    });

    test('tolerates unbalanced trailing parens and operators', () {
      expect(value('(2+3×(4'), 14);
      expect(value('5+'), 5);
      expect(value('√(16'), 4);
    });
  });

  group('CalculatorEngine errors', () {
    test('returns friendly error codes', () {
      expect(engine.evaluate('').error, CalculationError.emptyExpression);
      expect(
          engine.evaluate('2 + * 3').error, CalculationError.invalidExpression);
      expect(engine.evaluate('10 / 0').error, CalculationError.divideByZero);
      expect(engine.evaluate('log(0)').error, CalculationError.mathDomain);
      expect(engine.evaluate('asin(2)').error, CalculationError.mathDomain);
      expect(engine.evaluate('√(0−4)').error, CalculationError.mathDomain);
      expect(engine.evaluate('1..2').error, CalculationError.invalidExpression);
    });

    test('overflow is reported', () {
      expect(engine.evaluate('170!×10^300').error, CalculationError.overflow);
    });
  });

  group('CalculatorEngine helpers', () {
    test('openParenBalance counts correctly', () {
      expect(CalculatorEngine.openParenBalance('(2+(3'), 2);
      expect(CalculatorEngine.openParenBalance('(2)'), 0);
    });
  });
}
