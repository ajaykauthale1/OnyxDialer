import 'package:flutter/material.dart';

class AppTheme {
  static const Color _black = Color(0xFF000000);
  static const Color _darkGrey = Color(0xFF121212);
  static const Color _surface = Color(0xFF1E1E1E);
  static const Color _primary = Color(0xFF00E676); // Electric Green for calls
  static const Color _error = Color(0xFFCF6679);
  static const Color _onBackground = Color(0xFFE0E0E0);

  static final ThemeData grizzlyTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _black,
    colorScheme: const ColorScheme.dark(
      primary: _primary,
      secondary: _primary,
      surface: _surface,
      error: _error,
      onPrimary: _black,
      onSurface: _onBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _onBackground,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkGrey,
      indicatorColor: _primary.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: _black,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _onBackground),
      bodyLarge: TextStyle(fontSize: 16, color: _onBackground),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
    ),
    iconTheme: const IconThemeData(
      color: _onBackground,
    ),
  );
}
