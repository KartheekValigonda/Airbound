import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
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

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF006A67),
    scaffoldBackgroundColor: Colors.grey[800]!,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // High contrast for main text
      bodyMedium: TextStyle(color: Colors.white70), // Subtle for secondary text
      headlineSmall: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold), // Bold headers
    ),
    cardColor: Colors.grey[600],
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.teal,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF006A67),
      secondary: Colors.teal,
    ),
  );
}