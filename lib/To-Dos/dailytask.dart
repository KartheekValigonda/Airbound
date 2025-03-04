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
      body: SingleChildScrollView(
        child: Padding(
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
                    "Structuring Your \nDaily Routine",
                    style: theme.textTheme.headlineSmall?.copyWith(fontSize: 26),
                  ),
                  const CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                    radius: 25,
                  ),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                getFormattedDate(), // Display real date
                style: TextStyle(fontSize: 22, color: theme.colorScheme.primary),
              ),
              SizedBox(height: screenHeight*0.02),
              // Task List
              Text(
                "Morning Session:", // Display real date
                style: TextStyle(fontSize: 19, color: theme.colorScheme.primary),
              ),
              SizedBox(height: screenHeight*0.03),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  taskItem(true, "Warm-Up", Icons.bubble_chart_sharp,
                      theme.colorScheme.primary, details: ["5–10 minutes of dynamic stretching or light cardio"]),
                  taskItem(false, "Cardio", Icons.directions_run,
                      theme.colorScheme.primary, details: ["20–30 minutes of brisk walking, jogging, or cycling."]),
                  taskItem(false, "Cool-Down", Icons.air_outlined,
                      theme.colorScheme.primary, details: ["5 minutes of walking followed by static stretching."]),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                "Midday Session:", // Display real date
                style: TextStyle(fontSize: 19, color: theme.colorScheme.primary),
              ),
              SizedBox(height: screenHeight*0.02),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  taskItem(true, "Strength & Training", Icons.fitness_center,
                      theme.colorScheme.primary, details: ["15–20 minutes (alternating days with cardio)."]),
                  taskItem(false, "Breathing Exercises", Icons.air_sharp,
                      theme.colorScheme.primary, details: ["5 minutes of deep breathing or meditation."]),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                "Evening Session:", // Display real date
                style: TextStyle(fontSize: 19, color: theme.colorScheme.primary),
              ),
              SizedBox(height: screenHeight*0.02),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  taskItem(true, "Yoga", Icons.sports_gymnastics,
                      theme.colorScheme.primary, details: ["20–30 minutes (a calming yoga session or a leisurely walk outdoors)."]),
                  taskItem(false, "Cardio", Icons.directions_run,
                      theme.colorScheme.primary, details: ["5 minutes of stretching to relax your muscles."]),
                ],
              ),
            ],
          ),
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
                    ?.withValues()),
          ))
              .toList(),
        )
            : null,
        tileColor: isChecked ? iconColor.withValues() : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        trailing: Icon(icon, color: iconColor),
      ),
    );
  }
}