# Codex Implementation Prompt for CalcFlow MVP

Copy and paste the prompt below into Codex.

---

You are working in the GitHub repository `ranafaraz/italian-calculator`.

Build a production-quality Flutter MVP for an app called CalcFlow.

Before coding, read these documents carefully:

- `docs/PRD.md`
- `docs/ACCEPTANCE_CRITERIA.md`
- `docs/TEST_PLAN.md`
- `docs/ARCHITECTURE.md`

## Product Summary

CalcFlow is an Italian-first, privacy-first, offline-capable calculator app. It must feel fast, clean, premium, and trustworthy. The MVP must focus on deterministic local calculation, searchable local history, Italian IVA tools, discount calculation, unit conversion, dark/light mode, and Italian/English localization.

Italian is the default language. English is available in Settings.

No backend, no login, no ads, no subscriptions, no AI, no OCR, no cloud sync in MVP.

## Technical Direction

Use Flutter stable.

Use a clean feature-based architecture.

Prefer Riverpod for state management.

Use local storage for history and settings. Drift/SQLite is preferred for searchable history. Hive is acceptable if implemented cleanly.

Separate domain logic from UI.

All calculator, finance, and conversion logic must be covered by unit tests.

All user-facing strings must use localization files.

## Required Features

### 1. Basic Calculator

Implement:

- Addition
- Subtraction
- Multiplication
- Division
- Decimal support
- Parentheses
- Percentage
- Clear
- Backspace
- Copy result
- Editable expression display
- Operator precedence
- Friendly invalid expression error
- Friendly divide-by-zero error

### 2. Scientific Calculator

Implement:

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

Implement local-only history:

- Save expression
- Save result
- Save date/time
- Search history
- Delete one item
- Clear all
- Pin/favorite calculation
- Reuse previous calculation
- Persist after app restart

### 4. Italian Finance Tools

Implement:

- IVA calculator
- IVA rates: 4%, 5%, 10%, 22%, custom
- Net to gross
- Gross to net
- Show IVA amount separately
- Discount calculator

### 5. Unit Converter

Implement offline unit converter for:

- Length
- Weight/mass
- Temperature
- Area
- Volume
- Data
- Speed

### 6. Settings

Implement:

- Italian/English language switch
- Light/dark mode switch
- Decimal precision setting
- Clear all local data

## UI/UX Requirements

Create a polished premium UI inspired by the project direction:

- Main calculator is the default screen.
- Large tactile buttons.
- Strong expression/result hierarchy.
- Clean mode switcher: Base, Scientifica, Converti, Finanza, Impostazioni.
- Dark and light themes.
- Smooth, uncluttered layout.
- No intrusive modal.
- No fake loading screen.
- No ad placeholders.
- No login prompts.

The UI should be good enough for beta testing, not just developer scaffolding.

## Suggested Structure

```text
lib/
  main.dart
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

## Testing Requirements

Add tests for at least:

- Basic arithmetic
- Operator precedence
- Parentheses
- Invalid expressions
- Divide by zero
- Scientific functions
- IVA calculations
- Discount calculations
- Unit conversions
- History service or repository where practical

The following must pass:

```bash
flutter analyze
flutter test
```

Also update README with:

- Project overview
- Setup commands
- Run commands
- Test commands
- MVP scope
- Known non-goals

## Important Discipline

Do not implement non-MVP features.

Do not add AI.

Do not add backend.

Do not add login.

Do not add ads.

Do not add payments.

Do not add cloud sync.

Build the app in small, coherent changes. Prioritize correctness and clean architecture over feature bloat.

When done, summarize:

1. Files created/changed
2. Features implemented
3. Tests added
4. Commands run and their results
5. Remaining limitations
