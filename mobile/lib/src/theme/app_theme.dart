import 'package:flutter/material.dart';

abstract final class AppPalette {
  static const ink = Color(0xFF26324A);
  static const muted = Color(0xFF66708A);
  static const background = Color(0xFFF7FBFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceBlue = Color(0xFFEAF7FF);
  static const teal = Color(0xFF2EA99B);
  static const sky = Color(0xFF66C8F0);
  static const mango = Color(0xFFFFC857);
  static const coral = Color(0xFFFF6B6B);
  static const lavender = Color(0xFF8478FF);
  static const mint = Color(0xFFBFF6D0);
  static const border = Color(0xFFDCE8F5);
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppPalette.teal,
    primary: AppPalette.teal,
    secondary: AppPalette.mango,
    tertiary: AppPalette.lavender,
    error: AppPalette.coral,
    surface: AppPalette.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppPalette.background,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: AppPalette.ink,
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.08,
      ),
      headlineMedium: TextStyle(
        color: AppPalette.ink,
        fontSize: 27,
        fontWeight: FontWeight.w800,
        height: 1.12,
      ),
      headlineSmall: TextStyle(
        color: AppPalette.ink,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.14,
      ),
      titleLarge: TextStyle(
        color: AppPalette.ink,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        height: 1.18,
      ),
      titleMedium: TextStyle(
        color: AppPalette.ink,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        color: AppPalette.ink,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.42,
      ),
      bodyMedium: TextStyle(
        color: AppPalette.muted,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.42,
      ),
      bodySmall: TextStyle(
        color: AppPalette.muted,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.34,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
      foregroundColor: AppPalette.ink,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppPalette.ink,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppPalette.surface,
      margin: EdgeInsets.zero,
      shadowColor: AppPalette.ink.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppPalette.teal,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppPalette.border,
        disabledForegroundColor: AppPalette.muted,
        iconColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppPalette.ink,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppPalette.border, width: 1.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppPalette.teal,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      labelStyle: const TextStyle(
        color: AppPalette.muted,
        fontWeight: FontWeight.w700,
      ),
      prefixIconColor: AppPalette.teal,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppPalette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppPalette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppPalette.teal, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppPalette.coral, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppPalette.surface,
      checkmarkColor: AppPalette.ink,
      selectedColor: AppPalette.mint,
      side: const BorderSide(color: AppPalette.border),
      labelStyle: const TextStyle(
        color: AppPalette.ink,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppPalette.surface,
      elevation: 0,
      height: 76,
      indicatorColor: AppPalette.mint,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          color: selected ? AppPalette.ink : AppPalette.muted,
          fontSize: 12,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppPalette.teal : AppPalette.muted,
          size: selected ? 28 : 25,
        );
      }),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppPalette.ink,
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
