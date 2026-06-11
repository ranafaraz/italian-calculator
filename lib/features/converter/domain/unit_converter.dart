enum UnitCategory { length, mass, temperature, area, volume, data, speed, time }

class UnitDefinition {
  const UnitDefinition({
    required this.id,
    required this.category,
    required this.labelKey,
    required this.symbol,
    required this.toBaseFactor,
  });

  final String id;
  final UnitCategory category;

  /// Matches the l10n getter name (e.g. 'unitMeters').
  final String labelKey;
  final String symbol;
  final double toBaseFactor;
}

class UnitConverter {
  const UnitConverter();

  static const units = <UnitDefinition>[
    // Length (base: meter)
    UnitDefinition(id: 'm', category: UnitCategory.length, labelKey: 'unitMeters', symbol: 'm', toBaseFactor: 1),
    UnitDefinition(id: 'km', category: UnitCategory.length, labelKey: 'unitKilometers', symbol: 'km', toBaseFactor: 1000),
    UnitDefinition(id: 'cm', category: UnitCategory.length, labelKey: 'unitCentimeters', symbol: 'cm', toBaseFactor: 0.01),
    UnitDefinition(id: 'mm', category: UnitCategory.length, labelKey: 'unitMillimeters', symbol: 'mm', toBaseFactor: 0.001),
    UnitDefinition(id: 'mi', category: UnitCategory.length, labelKey: 'unitMiles', symbol: 'mi', toBaseFactor: 1609.344),
    UnitDefinition(id: 'yd', category: UnitCategory.length, labelKey: 'unitYards', symbol: 'yd', toBaseFactor: 0.9144),
    UnitDefinition(id: 'ft', category: UnitCategory.length, labelKey: 'unitFeet', symbol: 'ft', toBaseFactor: 0.3048),
    UnitDefinition(id: 'in', category: UnitCategory.length, labelKey: 'unitInches', symbol: 'in', toBaseFactor: 0.0254),

    // Mass (base: kilogram)
    UnitDefinition(id: 't', category: UnitCategory.mass, labelKey: 'unitTonnes', symbol: 't', toBaseFactor: 1000),
    UnitDefinition(id: 'kg', category: UnitCategory.mass, labelKey: 'unitKilograms', symbol: 'kg', toBaseFactor: 1),
    UnitDefinition(id: 'g', category: UnitCategory.mass, labelKey: 'unitGrams', symbol: 'g', toBaseFactor: 0.001),
    UnitDefinition(id: 'mg', category: UnitCategory.mass, labelKey: 'unitMilligrams', symbol: 'mg', toBaseFactor: 0.000001),
    UnitDefinition(id: 'lb', category: UnitCategory.mass, labelKey: 'unitPounds', symbol: 'lb', toBaseFactor: 0.45359237),
    UnitDefinition(id: 'oz', category: UnitCategory.mass, labelKey: 'unitOunces', symbol: 'oz', toBaseFactor: 0.028349523125),

    // Temperature (handled with offset formulas)
    UnitDefinition(id: 'c', category: UnitCategory.temperature, labelKey: 'unitCelsius', symbol: '°C', toBaseFactor: 1),
    UnitDefinition(id: 'f', category: UnitCategory.temperature, labelKey: 'unitFahrenheit', symbol: '°F', toBaseFactor: 1),
    UnitDefinition(id: 'k', category: UnitCategory.temperature, labelKey: 'unitKelvin', symbol: 'K', toBaseFactor: 1),

    // Area (base: square meter)
    UnitDefinition(id: 'sqm', category: UnitCategory.area, labelKey: 'unitSquareMeters', symbol: 'm²', toBaseFactor: 1),
    UnitDefinition(id: 'sqkm', category: UnitCategory.area, labelKey: 'unitSquareKilometers', symbol: 'km²', toBaseFactor: 1000000),
    UnitDefinition(id: 'ha', category: UnitCategory.area, labelKey: 'unitHectares', symbol: 'ha', toBaseFactor: 10000),

    // Volume (base: liter)
    UnitDefinition(id: 'l', category: UnitCategory.volume, labelKey: 'unitLiters', symbol: 'L', toBaseFactor: 1),
    UnitDefinition(id: 'ml', category: UnitCategory.volume, labelKey: 'unitMilliliters', symbol: 'mL', toBaseFactor: 0.001),
    UnitDefinition(id: 'cbm', category: UnitCategory.volume, labelKey: 'unitCubicMeters', symbol: 'm³', toBaseFactor: 1000),
    UnitDefinition(id: 'gal', category: UnitCategory.volume, labelKey: 'unitGallons', symbol: 'gal', toBaseFactor: 3.785411784),

    // Data (base: byte)
    UnitDefinition(id: 'b', category: UnitCategory.data, labelKey: 'unitBytes', symbol: 'B', toBaseFactor: 1),
    UnitDefinition(id: 'kb', category: UnitCategory.data, labelKey: 'unitKilobytes', symbol: 'KB', toBaseFactor: 1024),
    UnitDefinition(id: 'mb', category: UnitCategory.data, labelKey: 'unitMegabytes', symbol: 'MB', toBaseFactor: 1048576),
    UnitDefinition(id: 'gb', category: UnitCategory.data, labelKey: 'unitGigabytes', symbol: 'GB', toBaseFactor: 1073741824),
    UnitDefinition(id: 'tb', category: UnitCategory.data, labelKey: 'unitTerabytes', symbol: 'TB', toBaseFactor: 1099511627776),

    // Speed (base: meter/second)
    UnitDefinition(id: 'mps', category: UnitCategory.speed, labelKey: 'unitMetersPerSecond', symbol: 'm/s', toBaseFactor: 1),
    UnitDefinition(id: 'kph', category: UnitCategory.speed, labelKey: 'unitKilometersPerHour', symbol: 'km/h', toBaseFactor: 1 / 3.6),
    UnitDefinition(id: 'mph', category: UnitCategory.speed, labelKey: 'unitMilesPerHour', symbol: 'mph', toBaseFactor: 0.44704),
    UnitDefinition(id: 'kn', category: UnitCategory.speed, labelKey: 'unitKnots', symbol: 'kn', toBaseFactor: 0.514444),

    // Time (base: second)
    UnitDefinition(id: 'ms', category: UnitCategory.time, labelKey: 'unitMilliseconds', symbol: 'ms', toBaseFactor: 0.001),
    UnitDefinition(id: 's', category: UnitCategory.time, labelKey: 'unitSeconds', symbol: 's', toBaseFactor: 1),
    UnitDefinition(id: 'min', category: UnitCategory.time, labelKey: 'unitMinutes', symbol: 'min', toBaseFactor: 60),
    UnitDefinition(id: 'h', category: UnitCategory.time, labelKey: 'unitHours', symbol: 'h', toBaseFactor: 3600),
    UnitDefinition(id: 'd', category: UnitCategory.time, labelKey: 'unitDays', symbol: 'd', toBaseFactor: 86400),
    UnitDefinition(id: 'wk', category: UnitCategory.time, labelKey: 'unitWeeks', symbol: 'wk', toBaseFactor: 604800),
    UnitDefinition(id: 'yr', category: UnitCategory.time, labelKey: 'unitYears', symbol: 'yr', toBaseFactor: 31536000),
  ];

  List<UnitDefinition> unitsFor(UnitCategory category) {
    return units
        .where((unit) => unit.category == category)
        .toList(growable: false);
  }

  double convert({
    required double value,
    required UnitDefinition from,
    required UnitDefinition to,
  }) {
    if (from.category != to.category) {
      throw ArgumentError('Units must belong to the same category.');
    }
    if (!value.isFinite) {
      throw ArgumentError.value(value, 'value');
    }

    if (from.category == UnitCategory.temperature) {
      return _fromCelsius(_toCelsius(value, from.id), to.id);
    }

    final baseValue = value * from.toBaseFactor;
    return baseValue / to.toBaseFactor;
  }

  double _toCelsius(double value, String unitId) {
    return switch (unitId) {
      'c' => value,
      'f' => (value - 32) * 5 / 9,
      'k' => value - 273.15,
      _ => throw ArgumentError.value(unitId, 'unitId'),
    };
  }

  double _fromCelsius(double value, String unitId) {
    return switch (unitId) {
      'c' => value,
      'f' => value * 9 / 5 + 32,
      'k' => value + 273.15,
      _ => throw ArgumentError.value(unitId, 'unitId'),
    };
  }
}
