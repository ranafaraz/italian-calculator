import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/app_number_format.dart';
import '../../history/application/history_controller.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/calculator_engine.dart';

final calculatorEngineProvider = Provider<CalculatorEngine>((ref) {
  return const CalculatorEngine();
});

final calculatorControllerProvider =
    StateNotifierProvider<CalculatorController, CalculatorState>((ref) {
  return CalculatorController(ref);
});

class CalculatorState {
  const CalculatorState({
    this.expression = '',
    this.cursor = 0,
    this.preview = '',
    this.result = '',
    this.error,
    this.angleMode = AngleMode.degrees,
    this.sciOpen = false,
    this.inverse = false,
    this.justEvaluated = false,
    this.ans = 0,
  });

  /// Display expression — uses pretty glyphs (× ÷ − √ π) and the locale's
  /// decimal separator. The engine parses these directly, so what you see
  /// is exactly what gets evaluated.
  final String expression;
  final int cursor;

  /// Live result while typing (already formatted), '' when not computable.
  final String preview;

  /// Committed result after '='.
  final String result;
  final CalculationError? error;
  final AngleMode angleMode;
  final bool sciOpen;
  final bool inverse;
  final bool justEvaluated;
  final double ans;

  CalculatorState copyWith({
    String? expression,
    int? cursor,
    String? preview,
    String? result,
    CalculationError? error,
    bool clearError = false,
    AngleMode? angleMode,
    bool? sciOpen,
    bool? inverse,
    bool? justEvaluated,
    double? ans,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      cursor: cursor ?? this.cursor,
      preview: preview ?? this.preview,
      result: result ?? this.result,
      error: clearError ? null : error ?? this.error,
      angleMode: angleMode ?? this.angleMode,
      sciOpen: sciOpen ?? this.sciOpen,
      inverse: inverse ?? this.inverse,
      justEvaluated: justEvaluated ?? this.justEvaluated,
      ans: ans ?? this.ans,
    );
  }
}

class CalculatorController extends StateNotifier<CalculatorState> {
  CalculatorController(this._ref) : super(const CalculatorState());

  final Ref _ref;

  // Includes both the display minus '−' and ASCII '-' (keyboard input).
  static const _binaryOperators = '+−×÷^-';
  // Characters a value can end with ('s' covers the Ans token).
  static const _postfixStarters = '0123456789)!%²πes';
  static const _functionTokens = [
    'asin(', 'acos(', 'atan(', 'sin(', 'cos(', 'tan(',
    'log(', 'ln(', 'abs(', 'Ans',
  ];

  CalculatorEngine get _engine => _ref.read(calculatorEngineProvider);

  int get _precision =>
      _ref.read(settingsControllerProvider).decimalPrecision;

  String get _locale =>
      _ref.read(settingsControllerProvider).locale.languageCode;

  String get _decimalSeparator => AppNumberFormat.decimalSeparator(_locale);

  // ---------------------------------------------------------------------
  // Input
  // ---------------------------------------------------------------------

  void insertDigit(String digit) {
    _startNewIfEvaluated();
    _insertAtCursor(digit);
  }

  void insertOperator(String op) {
    _continueWithAnsIfEvaluated();
    final expr = state.expression;
    final cursor = state.cursor;
    final before = cursor > 0 ? expr[cursor - 1] : '';

    if (before.isEmpty || before == '(') {
      // Only unary minus may start an expression / follow '('.
      if (op == '−') {
        _insertAtCursor(op);
      }
      return;
    }
    if (_binaryOperators.contains(before)) {
      // Allow '5×−3'; otherwise replace the previous operator.
      if (op == '−' && before != '−') {
        _insertAtCursor(op);
      } else {
        _setExpression(
          expr.replaceRange(cursor - 1, cursor, op),
          cursor,
        );
      }
      return;
    }
    if (before == _decimalSeparator || before == ',' || before == '.') {
      return;
    }
    _insertAtCursor(op);
  }

  /// Postfix keys: % ! ² — only valid after a value.
  void insertPostfix(String token) {
    if (state.justEvaluated) {
      _continueWithAnsIfEvaluated();
    }
    final cursor = state.cursor;
    final before = cursor > 0 ? state.expression[cursor - 1] : '';
    if (before.isEmpty || !_postfixStarters.contains(before)) {
      return;
    }
    _insertAtCursor(token);
  }

  void insertDecimal() {
    _startNewIfEvaluated();
    final separator = _decimalSeparator;
    final expr = state.expression;
    final cursor = state.cursor;

    // Reject a second separator inside the current number.
    var i = cursor - 1;
    while (i >= 0 && (_isDigit(expr[i]) || expr[i] == ',' || expr[i] == '.')) {
      if (expr[i] == ',' || expr[i] == '.') {
        return;
      }
      i--;
    }
    var j = cursor;
    while (j < expr.length &&
        (_isDigit(expr[j]) || expr[j] == ',' || expr[j] == '.')) {
      if (expr[j] == ',' || expr[j] == '.') {
        return;
      }
      j++;
    }

    final needsLeadingZero = cursor == 0 || !_isDigit(expr[cursor - 1]);
    _insertAtCursor(needsLeadingZero ? '0$separator' : separator);
  }

  /// Inserts 'sin(' / '√(' / 'π' / 'e' / 'Ans' etc.
  void insertToken(String token) {
    _startNewIfEvaluated();
    _insertAtCursor(token);
  }

  /// Smart parenthesis: closes when there is something open to close,
  /// opens otherwise.
  void insertParen() {
    _startNewIfEvaluated();
    final expr = state.expression;
    final cursor = state.cursor;
    final before = cursor > 0 ? expr[cursor - 1] : '';
    final balance =
        CalculatorEngine.openParenBalance(expr.substring(0, cursor));
    final closes = balance > 0 &&
        before.isNotEmpty &&
        _postfixStarters.contains(before);
    _insertAtCursor(closes ? ')' : '(');
  }

  /// Toggles the sign of the number at the cursor.
  void toggleSign() {
    _continueWithAnsIfEvaluated();
    final expr = state.expression;
    var cursor = state.cursor;

    if (expr.isEmpty) {
      _insertAtCursor('−');
      return;
    }

    // Find the start of the number immediately left of the cursor.
    var start = cursor;
    while (start > 0 &&
        (_isDigit(expr[start - 1]) ||
            expr[start - 1] == ',' ||
            expr[start - 1] == '.')) {
      start--;
    }
    if (start == cursor) {
      // Not inside/after a number: allow a leading minus where valid.
      final before = cursor > 0 ? expr[cursor - 1] : '';
      if (before.isEmpty ||
          before == '(' ||
          _binaryOperators.contains(before)) {
        _insertAtCursor('−');
      }
      return;
    }

    final hasMinus = start > 0 && (expr[start - 1] == '−' || expr[start - 1] == '-');
    if (hasMinus) {
      final beforeMinus = start - 1 > 0 ? expr[start - 2] : '';
      final isUnary = beforeMinus.isEmpty ||
          beforeMinus == '(' ||
          _binaryOperators.contains(beforeMinus);
      if (isUnary) {
        _setExpression(
          expr.replaceRange(start - 1, start, ''),
          cursor - 1,
        );
        return;
      }
    }
    _setExpression(expr.replaceRange(start, start, '−'), cursor + 1);
  }

  void backspace() {
    if (state.justEvaluated) {
      // Editing after '=' keeps the expression, drops the committed result.
      state = state.copyWith(justEvaluated: false, result: '', clearError: true);
    }
    final expr = state.expression;
    final cursor = state.cursor;
    if (expr.isEmpty || cursor == 0) {
      return;
    }
    // Delete whole function tokens ('sin(', 'Ans') in one tap.
    for (final token in _functionTokens) {
      if (cursor >= token.length &&
          expr.substring(cursor - token.length, cursor) == token) {
        _setExpression(
          expr.replaceRange(cursor - token.length, cursor, ''),
          cursor - token.length,
        );
        return;
      }
    }
    _setExpression(expr.replaceRange(cursor - 1, cursor, ''), cursor - 1);
  }

  void clearAll() {
    state = CalculatorState(
      angleMode: state.angleMode,
      sciOpen: state.sciOpen,
      inverse: state.inverse,
      ans: state.ans,
    );
  }

  void setCursor(int cursor) {
    state = state.copyWith(cursor: cursor.clamp(0, state.expression.length));
  }

  /// Loads an expression (e.g. reused from history).
  void loadExpression(String expression) {
    state = state.copyWith(
      expression: expression,
      cursor: expression.length,
      result: '',
      justEvaluated: false,
      clearError: true,
      preview: _computePreview(expression),
    );
  }

  // ---------------------------------------------------------------------
  // Modes
  // ---------------------------------------------------------------------

  void toggleAngleMode() {
    state = state.copyWith(
      angleMode: state.angleMode == AngleMode.degrees
          ? AngleMode.radians
          : AngleMode.degrees,
      clearError: true,
    );
    state = state.copyWith(preview: _computePreview(state.expression));
  }

  void setSciOpen(bool open) {
    state = state.copyWith(sciOpen: open);
  }

  void toggleInverse() {
    state = state.copyWith(inverse: !state.inverse);
  }

  // ---------------------------------------------------------------------
  // Evaluation
  // ---------------------------------------------------------------------

  CalculationResult evaluate() {
    final expression = state.expression;
    final outcome = _engine.evaluate(
      expression,
      angleMode: state.angleMode,
      ansValue: state.ans,
    );
    if (outcome.isSuccess) {
      final formatted = AppNumberFormat.format(
        outcome.value!,
        locale: _locale,
        maxDecimals: _precision,
      );
      state = state.copyWith(
        result: formatted,
        preview: '',
        ans: outcome.value,
        justEvaluated: true,
        clearError: true,
      );
      _ref
          .read(historyControllerProvider.notifier)
          .add(expression, formatted);
    } else if (outcome.error != CalculationError.emptyExpression) {
      state = state.copyWith(error: outcome.error);
    }
    return outcome;
  }

  // ---------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------

  void _startNewIfEvaluated() {
    if (state.justEvaluated) {
      state = state.copyWith(
        expression: '',
        cursor: 0,
        result: '',
        preview: '',
        justEvaluated: false,
        clearError: true,
      );
    }
  }

  void _continueWithAnsIfEvaluated() {
    if (state.justEvaluated) {
      final continuation = AppNumberFormat.plain(
        state.ans,
        locale: _locale,
        maxDecimals: _precision,
      );
      state = state.copyWith(
        expression: continuation,
        cursor: continuation.length,
        result: '',
        preview: '',
        justEvaluated: false,
        clearError: true,
      );
    }
  }

  void _insertAtCursor(String text) {
    final expr = state.expression;
    final cursor = state.cursor;
    _setExpression(expr.replaceRange(cursor, cursor, text), cursor + text.length);
  }

  void _setExpression(String expression, int cursor) {
    state = state.copyWith(
      expression: expression,
      cursor: cursor.clamp(0, expression.length),
      preview: _computePreview(expression),
      result: '',
      justEvaluated: false,
      clearError: true,
    );
  }

  String _computePreview(String expression) {
    if (!_isComputable(expression)) {
      return '';
    }
    final outcome = _engine.evaluate(
      expression,
      angleMode: state.angleMode,
      ansValue: state.ans,
    );
    if (!outcome.isSuccess) {
      return '';
    }
    return AppNumberFormat.format(
      outcome.value!,
      locale: _locale,
      maxDecimals: _precision,
    );
  }

  /// Preview only makes sense once the expression is more than a literal
  /// the user is still typing (an operator, function, constant, …).
  bool _isComputable(String expression) {
    var body = expression.trim();
    if (body.startsWith('−') || body.startsWith('-')) {
      body = body.substring(1);
    }
    if (body.isEmpty) {
      return false;
    }
    for (final rune in body.runes) {
      final char = String.fromCharCode(rune);
      if (!_isDigit(char) && char != ',' && char != '.') {
        return true;
      }
    }
    return false;
  }

  bool _isDigit(String char) =>
      char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
}
