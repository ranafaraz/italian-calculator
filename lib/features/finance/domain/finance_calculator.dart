class VatCalculation {
  const VatCalculation({
    required this.net,
    required this.gross,
    required this.vat,
    required this.rate,
  });

  final double net;
  final double gross;
  final double vat;
  final double rate;
}

class DiscountCalculation {
  const DiscountCalculation({
    required this.originalPrice,
    required this.discountRate,
    required this.discountAmount,
    required this.finalPrice,
  });

  final double originalPrice;
  final double discountRate;
  final double discountAmount;
  final double finalPrice;
}

class FinanceCalculator {
  const FinanceCalculator();

  VatCalculation netToGross(double net, double rate) {
    _validateAmount(net);
    _validateRate(rate);
    final vat = net * rate / 100;
    return VatCalculation(net: net, gross: net + vat, vat: vat, rate: rate);
  }

  VatCalculation grossToNet(double gross, double rate) {
    _validateAmount(gross);
    _validateRate(rate);
    final net = gross / (1 + rate / 100);
    return VatCalculation(net: net, gross: gross, vat: gross - net, rate: rate);
  }

  DiscountCalculation discount(double originalPrice, double discountRate) {
    _validateAmount(originalPrice);
    _validateRate(discountRate);
    final discountAmount = originalPrice * discountRate / 100;
    return DiscountCalculation(
      originalPrice: originalPrice,
      discountRate: discountRate,
      discountAmount: discountAmount,
      finalPrice: originalPrice - discountAmount,
    );
  }

  void _validateAmount(double value) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(value, 'value');
    }
  }

  void _validateRate(double value) {
    if (!value.isFinite || value < 0 || value > 100) {
      throw ArgumentError.value(value, 'rate');
    }
  }
}
