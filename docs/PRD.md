# CalcFlow Product Requirements Document

## Product Summary

CalcFlow is an Italian-first, privacy-first, offline-capable cross-platform calculator app. The product should feel faster, cleaner, and more trustworthy than generic ad-supported calculator apps. It should launch with a polished MVP focused on daily calculations, scientific calculations, searchable local history, Italian IVA workflows, discount calculation, unit conversion, and language switching between Italian and English.

The app must not be a cluttered all-in-one clone. It should be a premium-feeling utility with calm UI, large readable controls, no intrusive ads, no required login, and deterministic local calculation.

## Default Language

Italian is the default language.

English must be available from Settings.

All user-facing strings must use localization files. Do not hardcode UI text in widgets.

## Core Positioning

Italian: La calcolatrice veloce, privata e intelligente per la vita quotidiana.

English: The fast, private, intelligent calculator for everyday work.

## MVP Goals

1. Build a reliable calculator users can trust.
2. Make Italian IVA and daily finance calculations first-class features.
3. Provide useful local calculation history with search and pinning.
4. Work offline without account, backend, ads, AI, or cloud sync.
5. Establish a scalable Flutter architecture for future AI, sync, graphing, and premium modules.

## MVP Non-Goals

The following must not be implemented in MVP unless explicitly requested later:

- AI assistant
- Photo math solver
- OCR
- Cloud sync
- Login/account system
- Subscriptions or payments
- Ads
- Graphing
- Web backend
- Social sharing integrations
- Team or classroom mode

## Target Users

### Everyday users
Need fast arithmetic, percentages, discounts, and shopping calculations.

### Students
Need scientific mode, expression editing, history, and clean UI.

### Italian freelancers and small business users
Need IVA, discounts, margins, invoice-related quick calculations, and local history.

### Professionals
Need reliable calculations, searchable memory, export in future versions, and privacy.

## MVP Feature Scope

### 1. Basic Calculator

Required:

- Addition
- Subtraction
- Multiplication
- Division
- Decimal input
- Parentheses
- Percentage
- Clear
- Backspace
- Copy result
- Editable expression display
- Operator precedence
- Friendly error states
- Divide-by-zero handling

### 2. Scientific Calculator

Required:

- sin
- cos
- tan
- log
- ln
- square root
- power
- pi
- e
- degree/radian toggle

### 3. History

Required:

- Save expression
- Save result
- Save date/time
- Search history
- Delete one history item
- Clear all history
- Pin/favorite calculation
- Reuse previous calculation
- Store locally only

### 4. Italian Finance Tools

Required:

- IVA calculator
- IVA rates: 4%, 5%, 10%, 22%, custom
- Calculate gross from net
- Calculate net from gross
- Show IVA amount clearly
- Discount calculator

### 5. Unit Converter

Required categories:

- Length
- Weight/mass
- Temperature
- Area
- Volume
- Data
- Speed

All unit conversion must work offline.

### 6. Settings

Required:

- Language switch: Italian / English
- Light / dark mode
- Decimal precision setting
- Clear all local data

## UX Principles

- No splash delay.
- No modal on first calculation.
- No upsell during calculation.
- Large buttons.
- High contrast text.
- Clear hierarchy between expression and result.
- Calm, premium visual style.
- One-hand friendly mobile layout.
- Tablet-ready layout architecture.
- Smooth mode switching.

## Recommended Navigation

Bottom or top mode selector:

- Base
- Scientifica
- Converti
- Finanza
- Impostazioni

History should be reachable from the calculator screen through a drawer, bottom sheet, or dedicated tab.

## Technical Stack

- Flutter stable
- Dart
- Riverpod or Bloc for state management
- Hive or Drift/SQLite for local storage
- Flutter localization / ARB files for i18n
- Unit tests for calculation engine, IVA, and conversions
- Widget tests for main flows

## Architecture Requirements

Separate calculation logic from UI.

Suggested folder structure:

```text
lib/
  app/
  core/
  features/
    calculator/
    scientific/
    history/
    finance/
    converter/
    settings/
  l10n/
  shared/
test/
```

## Success Criteria

MVP is successful when:

- App launches successfully on Android emulator.
- App can be built for iOS by a developer with macOS/Xcode.
- `flutter analyze` passes.
- `flutter test` passes.
- Italian is default language.
- English language switch works.
- Basic calculator returns correct results.
- Scientific calculator returns correct results.
- IVA calculations are correct.
- History persists after restart.
- Unit converter works offline.
- No backend dependency exists.
- No AI, ads, login, or payments exist in MVP.
