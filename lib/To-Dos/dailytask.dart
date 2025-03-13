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
                  Text("Structuring Your \nDaily Routine", style: theme.textTheme.bodyLarge),
                  const CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                    radius: 25,
                  ),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                getFormattedDate(), // Display real date
                  style: theme.textTheme.bodyMedium
              ),
              SizedBox(height: screenHeight*0.02),
              // Task List
              Text(
                "Morning Session:", // Display real date
                  style: theme.textTheme.bodyMedium
              ),
              SizedBox(height: screenHeight*0.03),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  taskItem(true, "Warm-Up", Icons.bubble_chart_sharp,
                      Colors.black, details: ["5–10 minutes of dynamic stretching or light cardio"]),
                  taskItem(false, "Cardio", Icons.directions_run,
                      Colors.black, details: ["20–30 minutes of brisk walking, jogging, or cycling."]),
                  taskItem(false, "Cool-Down", Icons.air_outlined,
                      Colors.black, details: ["5 minutes of walking followed by static stretching."]),
                ],
              ),
              SizedBox(height: screenHeight*0.02),
              Text(
                "Evening Session:", // Display real date
                style: TextStyle(fontSize: 19, color: Colors.black),
              ),
              SizedBox(height: screenHeight*0.02),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  taskItem(true, "Yoga", Icons.sports_gymnastics,
                      Colors.black, details: ["20–30 minutes (a calming yoga session or a leisurely walk outdoors)."]),
                  taskItem(false, "Cardio", Icons.directions_run,
                      Colors.black, details: ["5 minutes of stretching to relax your muscles."]),
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
        color: theme.appBarTheme.backgroundColor, // Use card color from theme
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
                style: theme.textTheme.bodyMedium
            ),
          ],
        ),
        subtitle: details != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details
              .map((detail) => Text(
            detail,
              style: theme.textTheme.bodySmall
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