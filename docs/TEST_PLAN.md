# CalcFlow Test Plan

## Purpose

CalcFlow is a calculator. Accuracy, reliability, and trust matter more than feature volume. This test plan defines the minimum testing needed before beta.

## Required Commands

Run before every merge:

```bash
flutter analyze
flutter test
```

Recommended local manual run:

```bash
flutter run
```

Recommended Android debug build:

```bash
flutter build apk --debug
```

## Unit Test Coverage

### Calculator Engine

Test these expressions at minimum:

| Expression | Expected |
|---|---:|
| 2 + 2 | 4 |
| 2 + 3 * 4 | 14 |
| (2 + 3) * 4 | 20 |
| 10 / 4 | 2.5 |
| 0.1 + 0.2 | precision-safe result based on configured rounding |
| 100 - 25% | clear documented behavior |
| 200 * 10% | 20 or documented percentage behavior |
| 2 ^ 3 | 8 |
| sqrt(81) | 9 |
| log(100) | 2 |
| ln(e) | 1 |
| sin(90) in degrees | 1 |
| cos(0) | 1 |
| tan(45) in degrees | 1 |

Error tests:

- Divide by zero
- Invalid syntax
- Unmatched parentheses
- Empty expression
- Multiple operators in invalid sequence

### IVA Calculator

Test:

| Case | Expected |
|---|---:|
| Net 100 + IVA 22% | Gross 122, IVA 22 |
| Gross 122 with IVA 22% | Net 100, IVA 22 |
| Net 100 + IVA 10% | Gross 110, IVA 10 |
| Gross 110 with IVA 10% | Net 100, IVA 10 |
| Net 100 + IVA 4% | Gross 104, IVA 4 |
| Custom IVA 7.5% on net 200 | Gross 215, IVA 15 |

### Discount Calculator

Test:

| Case | Expected |
|---|---:|
| 100 with 20% discount | final 80, discount 20 |
| 49.99 with 10% discount | final 44.991 before rounding |
| 100 with 0% discount | final 100 |
| 100 with 100% discount | final 0 |

### Unit Converter

Test representative conversions:

- 1 km = 1000 m
- 1 m = 100 cm
- 1 kg = 1000 g
- 0 Celsius = 32 Fahrenheit
- 100 Celsius = 212 Fahrenheit
- 1 GB = 1024 MB if using binary mode, or document decimal mode if using 1000
- 1 m/s = 3.6 km/h

## Widget Tests

Minimum widget tests:

- App loads with Italian locale by default.
- Calculator screen renders.
- User can input `2 + 2` and see `4`.
- User can switch to English.
- User can open settings.
- User can open history.
- Dark mode toggle changes theme.

## Manual Testing Checklist

### Launch and Navigation

- App opens without crash.
- Main calculator is default screen.
- Mode switching works.
- Settings screen opens.
- History opens and closes smoothly.

### Offline Behavior

- Turn off internet.
- Basic calculator works.
- Scientific calculator works.
- IVA calculator works.
- Unit converter works.
- History persists.

### Persistence

- Perform calculation.
- Close app.
- Reopen app.
- Confirm history remains.

### Localization

- Fresh install opens in Italian.
- Switch to English.
- Restart app.
- Confirm English remains selected.
- Switch back to Italian.

### Visual QA

- Check light mode.
- Check dark mode.
- Check long expressions.
- Check large numbers.
- Check small screen emulator.
- Check tablet-sized emulator if available.

### Accessibility

- Text should be readable.
- Buttons should have semantic labels.
- Touch targets should be large enough.
- Color contrast must be acceptable in light and dark modes.

## Beta Readiness

Before beta:

- Analyzer passes.
- Tests pass.
- No crash in 30 minutes of manual use.
- APK debug build works.
- README setup instructions are accurate.
- Known limitations are documented.
