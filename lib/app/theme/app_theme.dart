import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calc_colors.dart';

/// CalcFlow theme. Fonts are bundled (no network fetch, fully offline):
/// - Inter for UI text
/// - Space Grotesk for numerals / display
class AppTheme {
  AppTheme._();

  static const uiFont = 'Inter';
  static const numberFont = 'Space Grotesk';

  static ThemeData light() => _build(Brightness.light, CalcColors.light);

  static ThemeData dark() => _build(Brightness.dark, CalcColors.dark);

  static ThemeData _build(Brightness brightness, CalcColors calc) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: calc.accent,
      brightness: brightness,
      primary: calc.accent,
      surface: calc.surface,
      surfaceContainerHighest: calc.surfaceAlt,
      surfaceContainerHigh: calc.surfaceAlt,
      error: calc.danger,
      outlineVariant: calc.cardBorder,
    );

    final baseText = (brightness == Brightness.dark
            ? Typography.whiteMountainView
            : Typography.blackMountainView)
        .apply(fontFamily: uiFont)
        .copyWith(
          displayLarge: TextStyle(
            fontFamily: numberFont,
            fontWeight: FontWeight.w600,
            color: calc.textPrimary,
            letterSpacing: -1,
          ),
          displayMedium: TextStyle(
            fontFamily: numberFont,
            fontWeight: FontWeight.w600,
            color: calc.textPrimary,
            letterSpacing: -0.5,
          ),
          displaySmall: TextStyle(
            fontFamily: numberFont,
            fontWeight: FontWeight.w500,
            color: calc.textPrimary,
          ),
          headlineMedium: TextStyle(
            fontFamily: numberFont,
            fontWeight: FontWeight.w600,
            color: calc.textPrimary,
          ),
          titleLarge: TextStyle(
            fontFamily: uiFont,
            fontWeight: FontWeight.w700,
            color: calc.textPrimary,
            letterSpacing: -0.3,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: calc.background,
      fontFamily: uiFont,
      textTheme: baseText,
      extensions: [calc],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: calc.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: uiFont,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: -0.3,
          color: calc.textPrimary,
        ),
        iconTheme: IconThemeData(color: calc.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: calc.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: calc.cardBorder),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: calc.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: calc.accentSoft,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: uiFont,
            fontSize: 11.5,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? calc.accent
                : calc.textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? calc.accent
                : calc.textSecondary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: calc.surfaceAlt,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: calc.accent, width: 1.6),
        ),
        labelStyle: TextStyle(color: calc.textSecondary),
        hintStyle: TextStyle(color: calc.textSecondary),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: calc.surfaceAlt,
          foregroundColor: calc.textSecondary,
          selectedBackgroundColor: calc.accentSoft,
          selectedForegroundColor: calc.accent,
          side: BorderSide(color: calc.cardBorder),
          textStyle: const TextStyle(
            fontFamily: uiFont,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: calc.surfaceAlt,
        selectedColor: calc.accentSoft,
        checkmarkColor: calc.accent,
        labelStyle: TextStyle(
          fontFamily: uiFont,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: calc.textPrimary,
        ),
        side: BorderSide(color: calc.cardBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: calc.accent,
          foregroundColor:
              brightness == Brightness.dark ? const Color(0xFF04150D) : Colors.white,
          textStyle: const TextStyle(
            fontFamily: uiFont,
            fontWeight: FontWeight.w700,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            brightness == Brightness.dark ? calc.surfaceAlt : const Color(0xFF1E2630),
        contentTextStyle: const TextStyle(
          fontFamily: uiFont,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(color: calc.cardBorder, thickness: 1),
      listTileTheme: ListTileThemeData(
        iconColor: calc.textSecondary,
        titleTextStyle: TextStyle(
          fontFamily: uiFont,
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: calc.textPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: uiFont,
          fontSize: 13,
          color: calc.textSecondary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : calc.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? calc.accent
              : calc.surfaceAlt,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : calc.cardBorder,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: calc.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: calc.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: calc.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
