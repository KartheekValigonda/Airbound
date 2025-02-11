import 'package:flutter/material.dart';

Widget infoCard(String value, String label, IconData icon, width) {
  return Container(
    width: width,
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
    ),
    child: Column(
      children: [
        Icon(icon, color: Colors.teal, size: 32),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ),
  );
}