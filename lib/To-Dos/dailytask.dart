import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class Dailytask extends StatefulWidget {
  const Dailytask({super.key});

  @override
  State<Dailytask> createState() => _DailytaskState();
}

class _DailytaskState extends State<Dailytask> {
  // Method to get the formatted current date
  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, MMMM d').format(now); // e.g., "Monday, February 24"
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context); // Access theme data

    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow up"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.022),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's schedule",
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 28),
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                  radius: 25,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              getFormattedDate(), // Display real date
              style: TextStyle(fontSize: 22, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 20),
            // Task List
            Expanded(
              child: ListView(
                children: [
                  taskItem(true, "A Glass Of water", Icons.alarm,
                      theme.colorScheme.primary, details: ["06:00 hrs"]),
                  taskItem(false, "Morning Run", Icons.directions_run,
                      theme.colorScheme.primary, details: ["06:00 hrs"]),
                  taskItem(false, "Daily workout", Icons.fitness_center,
                      theme.colorScheme.primary, details: ["06:00 hrs"]),
                  taskItem(false, "Morning Run", Icons.laptop,
                      theme.colorScheme.primary, details: ["06:00 hrs"]),
                  taskItem(false, "Morning Run", Icons.restaurant,
                      theme.colorScheme.primary, details: ["06:00 hrs"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Task Item Widget
  Widget taskItem(bool isChecked, String title, IconData icon, Color iconColor,
      {List<String>? details}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015), // Should be 'bottom'
      decoration: BoxDecoration(
        color: theme.cardColor, // Use card color from theme
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
          ],
        ),
        subtitle: details != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details
              .map((detail) => Text(
            detail,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color
                    ?.withOpacity(0.7)),
          ))
              .toList(),
        )
            : null,
        tileColor: isChecked ? iconColor.withOpacity(0.2) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        trailing: Icon(icon, color: iconColor),
      ),
    );
  }
}