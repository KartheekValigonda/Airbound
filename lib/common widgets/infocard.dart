import 'package:flutter/material.dart';

Widget infoCard(String value, String label, IconData icon, double width, double height) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor, // Background from theme
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(height: 5),
            Text(
              value,
                style: theme.textTheme.bodySmall
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}