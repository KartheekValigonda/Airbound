import 'package:flutter/material.dart';

class Dailytask extends StatefulWidget {
  const Dailytask({super.key});

  @override
  State<Dailytask> createState() => _DailytaskState();
}

class _DailytaskState extends State<Dailytask> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Follow up",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF006A67),
        centerTitle: true, // Center the title text
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06, vertical: screenHeight*0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight*0.022),
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's schedule",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                  radius: 25,
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              "Monday 19",
              style: TextStyle(fontSize: 22, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            // Task List
            Expanded(
              child: ListView(
                children: [
                  taskItem(true, "A Glass Of water", Icons.alarm, Colors.teal, details: ["06:00 hrs"]),
                  taskItem(false, "Morning Run",  Icons.directions_run, Colors.teal, details: ["06:00 hrs"]),
                  taskItem(false, "Daily workout",  Icons.fitness_center, Colors.teal, details: ["06:00 hrs"]),
                  taskItem(false, "Morning Run",  Icons.laptop, Colors.teal, details: ["06:00 hrs"]),
                  taskItem(false, "Morning Run",  Icons.restaurant, Colors.teal, details: ["06:00 hrs"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Task Item Widget
  Widget taskItem(bool isChecked, String title, IconData icon, Color iconColor, {List<String>? details}) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight*0.015),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.black, fontSize: 18)),
          ],
        ),
        subtitle: details != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: details.map((detail) => Text(detail, style: const TextStyle(color: Colors.black45, fontSize: 12))).toList(),
        )
            : null,
        tileColor: isChecked ? iconColor.withOpacity(0.2) : Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leadingAndTrailingTextStyle: const TextStyle(color: Colors.white),
        trailing: Icon(icon, color: iconColor),
      ),
    );
  }
}