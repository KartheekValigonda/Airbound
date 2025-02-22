import 'package:flutter/material.dart';

Widget infoCard(String value, String label, IconData icon, double width) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        width: width,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: theme.cardColor, // Background from theme
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(height: 5),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    },
  );
}