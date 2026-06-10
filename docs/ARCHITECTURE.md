# CalcFlow Flutter Architecture Guide

## Architecture Goal

The codebase must be simple enough for MVP, but clean enough to support future AI, cloud sync, graphing, premium features, and web/desktop without major rewrites.

## Recommended Framework

Flutter stable.

## State Management

Use either Riverpod or Bloc. Prefer Riverpod for this MVP because it is lightweight, testable, and works well with feature-based architecture.

## Storage

Use local storage only.

Recommended options:

- Hive for simpler MVP storage.
- Drift/SQLite if stronger query/search behavior is needed.

Because searchable history is important, Drift/SQLite is preferred if the developer is comfortable with it. Hive is acceptable if search is implemented cleanly and the MVP remains simple.

## Folder Structure

```text
lib/
  main.dart
  app/
    calcflow_app.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_spacing.dart
      app_text_styles.dart
  core/
    errors/
    localization/
    storage/
    utils/
  features/
    calculator/
      domain/
      application/
      presentation/
      data/
    scientific/
      domain/
      application/
      presentation/
    history/
      domain/
      application/
      data/
      presentation/
    finance/
      domain/
      application/
      presentation/
    converter/
      domain/
      application/
      presentation/
    settings/
      domain/
      application/
      data/
      presentation/
  l10n/
    app_it.arb
    app_en.arb
  shared/
    widgets/
    components/
    extensions/
test/
```

## Layer Responsibilities

### Domain

Pure business logic. No Flutter widgets. No database code. No API code.

Examples:

- Expression evaluator
- IVA calculation
- Discount calculation
- Unit conversion
- History entity

### Application

State and use cases.

Examples:

- Calculator controller/provider
- History service
- Settings provider
- Finance calculator provider

### Data

Persistence and repositories.

Examples:

- Local history database
- Settings storage

### Presentation

Flutter UI widgets only.

Examples:

- Calculator screen
- Keypad widget
- History drawer
- Settings screen

## Calculation Engine

The calculation engine must be deterministic and local.

Requirements:

- No AI.
- No network calls.
- Unit tested.
- Handles decimal precision properly.
- Handles invalid expressions safely.
- Does not crash the UI.

Avoid putting calculation logic directly inside widgets.

## Localization

Use ARB localization files.

Default locale: Italian.

Required files:

```text
lib/l10n/app_it.arb
lib/l10n/app_en.arb
```

Do not hardcode user-facing strings in widgets.

## Theme System

Use a centralized theme layer.

Required:

- Light mode
- Dark mode
- Large readable calculator keys
- Consistent spacing scale
- Design tokens inspired by the design kit

## Testing Strategy

Unit tests should focus heavily on domain logic.

Required test areas:

- Calculator expression parser/evaluator
- Scientific operations
- IVA calculations
- Discount calculations
- Unit conversion
- History persistence/service behavior
- Localization basics

Widget tests should verify main screen rendering and basic interactions.

## CI Recommendation

Add GitHub Actions later, after the first Flutter project is committed.

Recommended workflow:

```yaml
name: Flutter CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

## Future Expansion Hooks

The MVP should leave room for:

- AI explain/check module
- Photo math
- Cloud sync
- Paid premium tier
- Graphing
- Export PDF/CSV
- Tablet split layout
- Web companion app

Do not implement these in MVP, but avoid architectural choices that block them.
