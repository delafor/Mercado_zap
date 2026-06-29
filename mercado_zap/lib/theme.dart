import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFF0F1F3),
      primaryContainer: Color.fromARGB(255, 101, 100, 100),
      onPrimary: Color(0xFFFFAC65),
      secondary: Color.fromARGB(255, 46, 135, 130),
      onSecondary: Color.fromARGB(255, 99, 188, 174),

      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFF8F9FF),
      onSurface: Color(0xFF191C20),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      canvasColor: const Color(0xFFF8F9FF),
      cardColor: const Color.fromARGB(255, 203, 204, 212),
      primaryColor: const Color(0xFFF0F1F3),

      dividerColor: const Color(0x1F191C20),
      disabledColor: const Color(0x61000000),

      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.compact,

      iconTheme: const IconThemeData(color: Color(0xDD000000)),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: Color(0xFF191C20),
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w400,
          color: Color(0xFF191C20),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFF191C20),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF191C20),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF191C20),
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
