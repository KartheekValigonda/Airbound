import 'dart:async';
import 'package:airbound/common%20widgets/infocard.dart';
import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int smokedToday = 0;
  int totalCigs = 0; // Accumulated count from previous days
  DateTime lastResetDate = DateTime.now();

  // These variables will store the computed values as strings.
  String misspend = "";
  String cigsmk = "";
  String life = "";
  String nic = "";

  // New variables for the "last smoked" timer.
  DateTime lastSmokeTime = DateTime.now();
  String timeSinceLastSmoke = "0 minutes, 0 hours, 0 days";
  Timer? _lastSmokeTimer;

  Timer? _timer;

  // Increment smokedToday and update related values.
  // Also, restart the "last smoked" timer.
  void increment() {
    setState(() {
      smokedToday++;
      lastSmokeTime = DateTime.now(); // reset timer on plus button tap
      _updateValues();
    });
  }

  // Decrement smokedToday (if greater than 0) and update related values.
  void decrement() {
    if (smokedToday > 0) {
      setState(() {
        smokedToday--;
        _updateValues();
      });
    }
  }

  // Helper function to update computed values using cumulative total.
  void _updateValues() {
    int cumulative = totalCigs + smokedToday;
    misspend = (cumulative * 20).toString();
    life = (cumulative * 11).toString();
    nic = (cumulative * 12).toString();
    cigsmk = cumulative.toString();
  }

  // Helper function to format a Duration as "X days, Y hours, Z minutes".
  String _formattedDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    return "$minutes mins, $hours hours, $days days";
  }

  @override
  void initState() {
    super.initState();
    lastResetDate = DateTime.now();
    lastSmokeTime = DateTime.now();
    _updateValues();
    // Set up a timer that checks every minute if the day has changed.
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      // Check if day changed.
      if (now.day != lastResetDate.day) {
        setState(() {
          // Add today's count to the cumulative total.
          totalCigs += smokedToday;
          smokedToday = 0;
          lastResetDate = now;
          _updateValues();
        });
      }
    });
    // Set up a timer to update the "last smoked" timer every second.
    _lastSmokeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        Duration diff = DateTime.now().difference(lastSmokeTime);
        timeSinceLastSmoke = _formattedDuration(diff);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _lastSmokeTimer?.cancel();
    super.dispose();
  }

  // Dummy main method (not used).
  void main() {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track and Crack",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF006A67),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "You last smoked:" text with timer
              Row(
                children: [
                  Text(
                    "You last smoked:",
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                  Text(
                    timeSinceLastSmoke,
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Cigarette Counter
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle,
                            size: 32, color: Colors.grey),
                        onPressed: decrement,
                      ),
                      Text(
                        "$smokedToday",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle,
                            size: 32, color: Colors.orange),
                        onPressed: increment,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text("Since you joined",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              // Display cumulative total of cigarettes smoked.
              Center(
                child: Container(
                  width: screenWidth * 0.83,
                  height: screenHeight * 0.075,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Total cigarette smoked after joining program",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        "$cigsmk",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              // Stats Cards (Row 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("₹$misspend", "Misspend", Icons.attach_money,
                      screenWidth * 0.4),
                  infoCard("$cigsmk", "cigs smoked", Icons.smoke_free,
                      screenWidth * 0.4),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              // Stats Cards (Row 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("$life mins", "life reduced", Icons.favorite,
                      screenWidth * 0.4),
                  infoCard("$nic mg", "Nicotine Consumed", Icons.bubble_chart,
                      screenWidth * 0.4),
                ],
              ),
              SizedBox(height: screenHeight * 0.025),
              _sinceYouJoined(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sinceYouJoined() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 4)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCardSmall("Doc", "Days Tacked", Icons.list),
                SizedBox(width: screenWidth * 0.05),
                _infoCardSmall("Doc", "Cigarettes Smoked", Icons.list),
                SizedBox(width: screenWidth * 0.05),
                _infoCardSmall("Doc", "Cigarettes Smoked", Icons.list),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCardSmall(String value, String label, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.5,
      height: screenHeight * 0.3,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(height: 5),
          Text(value,
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 3),
          Text(label,
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
