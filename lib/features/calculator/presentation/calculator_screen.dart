import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/calc_colors.dart';
import '../../../core/formatting/app_number_format.dart';
import '../../../core/haptics/haptics.dart';
import '../../history/presentation/history_sheet.dart';
import '../application/calculator_controller.dart';
import '../domain/calculator_engine.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  late final TextEditingController _expressionController;
  var _syncing = false;
  var _shakeTick = 0;

  CalculatorController get _controller =>
      ref.read(calculatorControllerProvider.notifier);

  Haptics get _haptics => ref.read(hapticsProvider);

  @override
  void initState() {
    super.initState();
    _expressionController = TextEditingController();
    _expressionController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
  }

  /// The display field is read-only, so the only user-driven change is the
  /// cursor position (tap to place the caret).
  void _onFieldChanged() {
    if (_syncing) {
      return;
    }
    final state = ref.read(calculatorControllerProvider);
    final selection = _expressionController.selection;
    if (_expressionController.text == state.expression &&
        selection.isValid &&
        selection.isCollapsed &&
        selection.baseOffset != state.cursor) {
      _controller.setCursor(selection.baseOffset);
    }
  }

  void _syncField(CalculatorState state) {
    if (_expressionController.text == state.expression &&
        _expressionController.selection.baseOffset == state.cursor) {
      return;
    }
    _syncing = true;
    _expressionController.value = TextEditingValue(
      text: state.expression,
      selection: TextSelection.collapsed(offset: state.cursor),
    );
    _syncing = false;
  }

  // -----------------------------------------------------------------------
  // Key handling
  // -----------------------------------------------------------------------

  void _onKey(String key) {
    _haptics.key();
    final inverse = ref.read(calculatorControllerProvider).inverse;
    switch (key) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        _controller.insertDigit(key);
        break;
      case 'sep':
        _controller.insertDecimal();
        break;
      case 'AC':
        _controller.clearAll();
        break;
      case 'back':
        _controller.backspace();
        break;
      case 'paren':
        _controller.insertParen();
        break;
      case '%':
      case '!':
      case '²':
        _controller.insertPostfix(key);
        break;
      case '÷':
      case '×':
      case '−':
      case '+':
      case '^':
        _controller.insertOperator(key);
        break;
      case '±':
        _controller.toggleSign();
        break;
      case '=':
        _evaluate();
        break;
      case 'sin':
      case 'cos':
      case 'tan':
        _controller.insertToken(inverse ? 'a$key(' : '$key(');
        break;
      case 'ln':
        _controller.insertToken(inverse ? 'e^(' : 'ln(');
        break;
      case 'log':
        _controller.insertToken(inverse ? '10^(' : 'log(');
        break;
      case '√':
        _controller.insertToken('√(');
        break;
      case 'π':
      case 'e':
      case 'Ans':
        _controller.insertToken(key);
        break;
      case 'INV':
        _controller.toggleInverse();
        break;
    }
  }

  void _evaluate() {
    final outcome = _controller.evaluate();
    if (outcome.isSuccess) {
      _haptics.confirm();
    } else if (outcome.error != CalculationError.emptyExpression) {
      _haptics.error();
      setState(() => _shakeTick++);
    }
  }

  KeyEventResult _onHardwareKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _onKey('=');
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      _onKey('back');
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape ||
        event.logicalKey == LogicalKeyboardKey.delete) {
      _onKey('AC');
      return KeyEventResult.handled;
    }
    final char = event.character;
    if (char == null || char.isEmpty) {
      return KeyEventResult.ignored;
    }
    const mapped = {
      '*': '×',
      'x': '×',
      '/': '÷',
      '-': '−',
      '.': 'sep',
      ',': 'sep',
      '=': '=',
    };
    if (RegExp(r'^[0-9]$').hasMatch(char)) {
      _onKey(char);
      return KeyEventResult.handled;
    }
    if (mapped.containsKey(char)) {
      _onKey(mapped[char]!);
      return KeyEventResult.handled;
    }
    if ('+^%!'.contains(char)) {
      _onKey(char == '+' ? '+' : char);
      return KeyEventResult.handled;
    }
    if (char == '(' || char == ')') {
      _controller.insertToken(char);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // -----------------------------------------------------------------------
  // History
  // -----------------------------------------------------------------------

  void _openHistory() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) => HistorySheet(
          scrollController: scrollController,
          onReuse: (expression) {
            _controller.loadExpression(expression);
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }

  void _copy(String text) {
    if (text.isEmpty) {
      return;
    }
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.copied)));
  }

  // -----------------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(calculatorControllerProvider);
    final separator = AppNumberFormat.decimalSeparator(
      Localizations.localeOf(context).languageCode,
    );

    ref.listen(calculatorControllerProvider, (_, next) => _syncField(next));
    _syncField(state);

    return Focus(
      autofocus: true,
      onKeyEvent: _onHardwareKey,
      child: Column(
        children: [
          _Header(onHistory: _openHistory),
          Expanded(
            flex: 5,
            child: _Display(
              controller: _expressionController,
              state: state,
              shakeTick: _shakeTick,
              errorText: _errorText(l10n, state.error),
              onCopy: _copy,
            ),
          ),
          _UtilityRow(
            state: state,
            l10n: l10n,
            onToggleSci: () {
              _haptics.key();
              _controller.setSciOpen(!state.sciOpen);
            },
            onToggleAngle: () {
              _haptics.key();
              _controller.toggleAngleMode();
            },
            onBackspace: () => _onKey('back'),
            onClearAll: () => _onKey('AC'),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: state.sciOpen
                ? _SciPanel(inverse: state.inverse, onKey: _onKey)
                : const SizedBox(width: double.infinity),
          ),
          Expanded(
            flex: 7,
            child: _Keypad(separator: separator, onKey: _onKey),
          ),
        ],
      ),
    );
  }

  String? _errorText(AppLocalizations l10n, CalculationError? error) {
    return switch (error) {
      CalculationError.invalidExpression => l10n.errorInvalid,
      CalculationError.divideByZero => l10n.errorDivideByZero,
      CalculationError.mathDomain => l10n.errorDomain,
      CalculationError.overflow => l10n.errorOverflow,
      CalculationError.emptyExpression || null => null,
    };
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.onHistory});

  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Calc',
                  style: TextStyle(color: calc.textPrimary),
                ),
                TextSpan(
                  text: 'Flow',
                  style: TextStyle(color: calc.accent),
                ),
              ],
            ),
            style: const TextStyle(
              fontFamily: AppTheme.uiFont,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: l10n.history,
            onPressed: onHistory,
            icon: Icon(Icons.history_rounded, color: calc.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Display
// ---------------------------------------------------------------------------

class _Display extends StatelessWidget {
  const _Display({
    required this.controller,
    required this.state,
    required this.shakeTick,
    required this.errorText,
    required this.onCopy,
  });

  final TextEditingController controller;
  final CalculatorState state;
  final int shakeTick;
  final String? errorText;
  final ValueChanged<String> onCopy;

  double _expressionFontSize(int length, bool evaluated) {
    if (evaluated) {
      return 22;
    }
    if (length <= 14) {
      return 40;
    }
    if (length <= 22) {
      return 33;
    }
    if (length <= 32) {
      return 27;
    }
    return 23;
  }

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);

    Widget secondLine;
    if (errorText != null) {
      secondLine = Text(
        errorText!,
        key: const ValueKey('error'),
        style: TextStyle(
          fontFamily: AppTheme.uiFont,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: calc.danger,
        ),
      );
    } else if (state.justEvaluated) {
      secondLine = GestureDetector(
        key: ValueKey('result-${state.result}'),
        onTap: () => onCopy(state.result),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            state.result,
            maxLines: 1,
            style: TextStyle(
              fontFamily: AppTheme.numberFont,
              fontSize: 46,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
              color: calc.accent,
            ),
          ),
        ),
      );
    } else if (state.preview.isNotEmpty) {
      secondLine = GestureDetector(
        key: ValueKey('preview-${state.preview}'),
        onTap: () => onCopy(state.preview),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '= ${state.preview}',
            maxLines: 1,
            style: TextStyle(
              fontFamily: AppTheme.numberFont,
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: calc.displayPreview,
            ),
          ),
        ),
      );
    } else {
      secondLine = const SizedBox(key: ValueKey('empty'));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TweenAnimationBuilder<double>(
            key: ValueKey(shakeTick),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 360),
            builder: (context, t, child) => Transform.translate(
              offset: Offset(math.sin(t * math.pi * 4) * 9 * (1 - t), 0),
              child: child,
            ),
            child: TextField(
              controller: controller,
              readOnly: true,
              showCursor: !state.justEvaluated,
              maxLines: 1,
              textAlign: TextAlign.end,
              cursorColor: calc.accent,
              keyboardType: TextInputType.none,
              style: TextStyle(
                fontFamily: AppTheme.numberFont,
                fontSize: _expressionFontSize(
                  state.expression.length,
                  state.justEvaluated,
                ),
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
                color: state.justEvaluated
                    ? calc.displayPreview
                    : calc.displayExpression,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                hintText: '0',
              ),
            ),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Align(
              alignment: Alignment.centerRight,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.25),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: secondLine,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Utility row: SCI toggle, DEG/RAD, backspace
// ---------------------------------------------------------------------------

class _UtilityRow extends StatelessWidget {
  const _UtilityRow({
    required this.state,
    required this.l10n,
    required this.onToggleSci,
    required this.onToggleAngle,
    required this.onBackspace,
    required this.onClearAll,
  });

  final CalculatorState state;
  final AppLocalizations l10n;
  final VoidCallback onToggleSci;
  final VoidCallback onToggleAngle;
  final VoidCallback onBackspace;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Row(
        children: [
          _Pill(
            selected: state.sciOpen,
            tooltip: l10n.scientificToggle,
            onTap: onToggleSci,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.functions_rounded,
                  size: 18,
                  color: state.sciOpen ? calc.accent : calc.textSecondary,
                ),
                const SizedBox(width: 4),
                Text('SCI'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (state.sciOpen)
            _Pill(
              selected: false,
              tooltip: l10n.angleMode,
              onTap: onToggleAngle,
              child: Text(
                state.angleMode == AngleMode.degrees ? 'DEG' : 'RAD',
              ),
            ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBackspace,
              onLongPress: onClearAll,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Icon(
                  Icons.backspace_outlined,
                  size: 24,
                  color: calc.keyOpFg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.selected,
    required this.tooltip,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final String tooltip;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? calc.accentSoft : calc.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? calc.accent : calc.cardBorder,
              ),
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                fontFamily: AppTheme.uiFont,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: selected ? calc.accent : calc.textSecondary,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Scientific panel
// ---------------------------------------------------------------------------

class _SciPanel extends StatelessWidget {
  const _SciPanel({required this.inverse, required this.onKey});

  final bool inverse;
  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    final rows = [
      [
        _SciKey('INV', 'INV', selected: inverse),
        _SciKey(inverse ? 'sin⁻¹' : 'sin', 'sin'),
        _SciKey(inverse ? 'cos⁻¹' : 'cos', 'cos'),
        _SciKey(inverse ? 'tan⁻¹' : 'tan', 'tan'),
      ],
      [
        _SciKey('π', 'π'),
        _SciKey('e', 'e'),
        _SciKey('xʸ', '^'),
        _SciKey('x!', '!'),
      ],
      [
        _SciKey('√', '√'),
        _SciKey(inverse ? 'eˣ' : 'ln', 'ln'),
        _SciKey(inverse ? '10ˣ' : 'log', 'log'),
        _SciKey('Ans', 'Ans'),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  for (final key in row)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _CalcKey(
                          label: key.label,
                          type: key.selected
                              ? _KeyType.sciActive
                              : _KeyType.sci,
                          height: 42,
                          fontSize: 15,
                          onTap: () => onKey(key.value),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SciKey {
  const _SciKey(this.label, this.value, {this.selected = false});

  final String label;
  final String value;
  final bool selected;
}

// ---------------------------------------------------------------------------
// Keypad
// ---------------------------------------------------------------------------

class _Keypad extends StatelessWidget {
  const _Keypad({required this.separator, required this.onKey});

  final String separator;
  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    final rows = [
      [
        const _KeySpec('AC', 'AC', _KeyType.danger, fontSize: 22),
        const _KeySpec('( )', 'paren', _KeyType.fn, fontSize: 22),
        const _KeySpec('%', '%', _KeyType.fn),
        const _KeySpec('÷', '÷', _KeyType.op),
      ],
      [
        const _KeySpec('7', '7', _KeyType.digit),
        const _KeySpec('8', '8', _KeyType.digit),
        const _KeySpec('9', '9', _KeyType.digit),
        const _KeySpec('×', '×', _KeyType.op),
      ],
      [
        const _KeySpec('4', '4', _KeyType.digit),
        const _KeySpec('5', '5', _KeyType.digit),
        const _KeySpec('6', '6', _KeyType.digit),
        const _KeySpec('−', '−', _KeyType.op),
      ],
      [
        const _KeySpec('1', '1', _KeyType.digit),
        const _KeySpec('2', '2', _KeyType.digit),
        const _KeySpec('3', '3', _KeyType.digit),
        const _KeySpec('+', '+', _KeyType.op),
      ],
      [
        const _KeySpec('±', '±', _KeyType.fn),
        const _KeySpec('0', '0', _KeyType.digit),
        _KeySpec(separator, 'sep', _KeyType.digit),
        const _KeySpec('=', '=', _KeyType.equals),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        children: [
          for (final row in rows)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    for (final spec in row)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _CalcKey(
                            label: spec.label,
                            type: spec.type,
                            fontSize: spec.fontSize,
                            onTap: () => onKey(spec.value),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _KeySpec {
  const _KeySpec(this.label, this.value, this.type, {this.fontSize = 26});

  final String label;
  final String value;
  final _KeyType type;
  final double fontSize;
}

enum _KeyType { digit, fn, op, equals, danger, sci, sciActive }

class _CalcKey extends StatefulWidget {
  const _CalcKey({
    required this.label,
    required this.type,
    required this.onTap,
    this.fontSize = 26,
    this.height,
  });

  final String label;
  final _KeyType type;
  final VoidCallback onTap;
  final double fontSize;
  final double? height;

  @override
  State<_CalcKey> createState() => _CalcKeyState();
}

class _CalcKeyState extends State<_CalcKey> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final calc = CalcColors.of(context);
    final isLight = Theme.of(context).brightness == Brightness.light;

    final (Color? bg, Color fg, Gradient? gradient) = switch (widget.type) {
      _KeyType.digit => (calc.keyDigitBg, calc.keyDigitFg, null),
      _KeyType.fn => (calc.keyFnBg, calc.keyFnFg, null),
      _KeyType.op => (calc.keyOpBg, calc.keyOpFg, null),
      _KeyType.danger => (calc.keyFnBg, calc.danger, null),
      _KeyType.equals => (null, calc.equalsFg, calc.equalsGradient),
      _KeyType.sci => (calc.surfaceAlt, calc.textSecondary, null),
      _KeyType.sciActive => (calc.accentSoft, calc.accent, null),
    };

    final radius = BorderRadius.circular(widget.height != null ? 14 : 20);

    final decoration = BoxDecoration(
      color: bg,
      gradient: gradient,
      borderRadius: radius,
      border: widget.type == _KeyType.equals
          ? null
          : Border.all(
              color: widget.type == _KeyType.sciActive
                  ? calc.accent
                  : calc.cardBorder,
            ),
      boxShadow: [
        if (widget.type == _KeyType.equals)
          BoxShadow(
            color: calc.equalsGradEnd.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          )
        else if (isLight && widget.type == _KeyType.digit)
          BoxShadow(
            color: calc.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
      ],
    );

    final fontWeight = switch (widget.type) {
      _KeyType.digit => FontWeight.w500,
      _KeyType.equals || _KeyType.op => FontWeight.w600,
      _ => FontWeight.w600,
    };

    return AnimatedScale(
      scale: _pressed ? 0.92 : 1,
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) => setState(() => _pressed = value),
          borderRadius: radius,
          splashColor: fg.withValues(alpha: 0.12),
          highlightColor: fg.withValues(alpha: 0.06),
          child: Ink(
            height: widget.height,
            decoration: decoration,
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: AppTheme.numberFont,
                  fontSize: widget.fontSize,
                  fontWeight: fontWeight,
                  color: fg,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
