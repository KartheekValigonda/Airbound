import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme(BuildContext context) {

    return ThemeData(
      useMaterial3: true,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF4e6655)),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 18, color: Colors.black),
        bodySmall: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}