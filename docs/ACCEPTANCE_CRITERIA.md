# CalcFlow MVP Acceptance Criteria

This document defines what must be true before the first MVP can be considered complete.

## General

- The app is built in Flutter.
- The app runs on Android.
- The codebase is structured for iOS support.
- The app has no backend dependency.
- The app has no login, ads, subscriptions, AI, OCR, or cloud sync in MVP.
- Italian is the default language.
- English is available through Settings.

## Commands

The following commands must pass before marking work complete:

```bash
flutter analyze
flutter test
```

If possible, also verify:

```bash
flutter run
flutter build apk --debug
```

## Basic Calculator

- User can enter numbers and operators.
- User can enter decimal values.
- User can use parentheses.
- User can calculate percentages.
- User can clear expression.
- User can backspace.
- User can copy result.
- Operator precedence is correct.
- Invalid expressions show friendly error.
- Divide by zero shows friendly error and does not crash.

## Scientific Calculator

- Supports sin, cos, tan.
- Supports log and ln.
- Supports square root.
- Supports powers.
- Supports pi and e constants.
- Supports degree/radian toggle.
- Scientific operations are covered by unit tests.

## History

- Calculation history is saved locally.
- Each item includes expression, result, date/time, and pinned status.
- History remains after app restart.
- User can search history.
- User can pin/favorite a calculation.
- User can delete one item.
- User can clear all history.
- User can reuse a previous expression.

## IVA and Discount

- IVA rates include 4%, 5%, 10%, 22%, and custom.
- Net to gross calculation is correct.
- Gross to net calculation is correct.
- IVA amount is displayed separately.
- Discount calculator shows original price, discount amount, and final price.

## Unit Converter

- Supports length, weight/mass, temperature, area, volume, data, and speed.
- Conversion works offline.
- Conversion logic has unit tests.

## Settings

- User can switch language between Italian and English.
- User can switch light/dark mode.
- User can set decimal precision.
- User can clear all local data.

## UX Quality

- Buttons are large and readable.
- UI is clean and premium.
- No cluttered all-in-one menu.
- Main calculator remains the default screen.
- Text has sufficient contrast in light and dark modes.
- UI does not freeze during typing.
- App should feel fast on emulator and mid-range Android.

## Definition of Done

MVP is done only when:

1. All required features above are implemented.
2. All tests pass.
3. Analyzer passes.
4. App launches and works offline.
5. README contains setup and test instructions.
6. No non-MVP features were added.
