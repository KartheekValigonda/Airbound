import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData appTheme(BuildContext context) {

    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF006A67),
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
        elevation: 2.0,
        centerTitle: true
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFAEC),
      useMaterial3: true,
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 18, color: Colors.black),
        bodySmall: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}