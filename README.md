# CalcFlow

CalcFlow is an Italian-first, privacy-first, fully offline calculator built with Flutter. Italian is the default language; English can be selected in Settings. All data stays on the device — no backend, no accounts, no ads.

## Features

### Calculator
- Live result preview while you type (commit with `=`)
- Smart parenthesis key, sign toggle (±), cursor-aware editing
- Percentages with calculator convention: `100 − 25% = 75`, `200 × 10% = 20`
- Scientific panel: sin/cos/tan (+ inverse via INV), ln/log (+ eˣ/10ˣ), √, x!, xʸ, π, e, Ans
- DEG/RAD angle modes, implicit multiplication (`2π`, `3(4+1)`), auto-closing parentheses
- Locale-aware numbers: `1.234,56` in Italian, `1,234.56` in English; comma decimal input
- Hardware keyboard support, haptic feedback, friendly localized errors

### History
- Persistent local history with search, pin, swipe-to-delete with undo
- Grouped by day (Today / Yesterday / date), tap to reuse, copy results

### Italian finance tools
- IVA: add VAT (netto → lordo) and scorporo (lordo → netto) with rates 4/5/10/22% or custom
- Discount calculator with quick percentages and "you save" breakdown
- Euro formatting per locale

### Unit converter
- 8 categories: length, weight, temperature, area, volume, data, speed, time
- Bidirectional editing (type in either field), instant swap, equivalence hint

### Settings
- Theme: system / light / dark
- Language: Italiano / English (Italian default)
- Decimal precision (0–10), haptic feedback toggle
- Clear all local data

## Design

Custom "Tricolore Premium" design system: neutral slate surfaces, emerald accent, warm amber operators, coral for destructive actions. Bundled Inter (UI) and Space Grotesk (numerals) fonts — no runtime font downloads, fully offline.

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run                 # any connected device
flutter run -d chrome       # web (desktop testing)
flutter build apk --debug   # Android APK → build/app/outputs/flutter-apk/
```

## Test

```bash
flutter analyze
flutter test
```

## Architecture

Feature-based structure; domain logic separated from UI and unit-tested. Riverpod for state, `shared_preferences` for local persistence, `flutter gen-l10n` for it/en localization.

```text
lib/
  app/            # MaterialApp, theme, design tokens (CalcColors)
  core/           # number formatting, haptics, storage
  features/
    calculator/   # engine (parser/evaluator), controller, screen
    history/      # repository, controller, bottom sheet
    finance/      # IVA + discount domain and screen
    converter/    # unit definitions and bidirectional screen
    settings/     # preferences state and screen
  l10n/           # app_it.arb (template), app_en.arb
  shared/         # app shell, shared widgets
test/
```

## Known non-goals

No AI, OCR, backend, login, cloud sync, ads, subscriptions, graphing, or social sharing.
