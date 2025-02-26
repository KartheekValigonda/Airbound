import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData appTheme = ThemeData(
    primaryColor: const Color(0xFF006A67),
    scaffoldBackgroundColor: const Color(0xFFFFFAEC),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF006A67),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87), // High contrast for main text
      bodyMedium: TextStyle(color: Colors.black54), // Subtle for secondary text
      headlineSmall: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold), // Bold headers
    ),
    cardColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF006A67),
      secondary: Colors.orangeAccent,
      surface: Colors.white,
    ),
  );
}