import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF00E676); // Neon Green
  static const Color _background = Color(0xFF121212); // Deep Dark
  static const Color _surface = Color(0xFF1E1E1E);
  static const Color _error = Color(0xFFCF6679);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      secondary: _primary,
      surface: _surface,
      background: _background,
      error: _error,
      onPrimary: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: _background,
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      elevation: 0,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _surface,
      indicatorColor: _primary.withOpacity(0.2),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.black,
    ),
    // Removed CardTheme to avoid version conflict
  );
}
