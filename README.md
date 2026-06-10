# CalcFlow — Italian-first Calculator App

CalcFlow is an Italian-first, privacy-first, offline-capable cross-platform calculator app planned for Flutter.

The product goal is to build a fast, clean, premium-feeling calculator for daily calculations, scientific calculations, Italian IVA workflows, discount calculation, unit conversion, searchable local history, and Italian/English localization.

## Current Repository Status

This repository currently contains the planning package for Codex implementation.

## Planning Documents

- [`docs/PRD.md`](docs/PRD.md) — product requirements
- [`docs/ACCEPTANCE_CRITERIA.md`](docs/ACCEPTANCE_CRITERIA.md) — MVP definition of done
- [`docs/TEST_PLAN.md`](docs/TEST_PLAN.md) — test plan and manual QA checklist
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — recommended Flutter architecture
- [`docs/CODEX_PROMPT.md`](docs/CODEX_PROMPT.md) — prompt to execute in Codex

## MVP Scope

The MVP should include:

- Basic calculator
- Scientific calculator
- Local searchable history
- Italian IVA calculator
- Discount calculator
- Offline unit converter
- Italian default language
- English language switch
- Light/dark mode
- Decimal precision setting
- Local-only storage

## MVP Non-Goals

Do not implement these in MVP:

- AI
- OCR/photo math
- Login
- Backend
- Cloud sync
- Ads
- Payments/subscriptions
- Graphing

## Recommended Stack

- Flutter stable
- Dart
- Riverpod or Bloc
- Drift/SQLite or Hive for local storage
- Flutter localization / ARB files
- Unit and widget tests

## Required Quality Gates

Codex/developer should not mark the MVP complete unless these pass:

```bash
flutter analyze
flutter test
```

## Codex Start Point

Open `docs/CODEX_PROMPT.md`, copy the implementation prompt, and run it in Codex.
