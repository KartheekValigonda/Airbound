import 'dart:async';
import 'package:airbound/common%20widgets/infocard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int smokedToday = 0;
  int totalCigs = 0;
  DateTime lastResetDate = DateTime.now();
  DateTime lastSmokeTime = DateTime.now();

  String misspend = "";
  String cigsmk = "";
  String life = "";
  String nic = "";
  String timeSinceLastSmoke = "0 minutes, 0 hours, 0 days";

  Timer? _timer;
  Timer? _lastSmokeTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startTimers();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      smokedToday = prefs.getInt('smokedToday') ?? 0;
      totalCigs = prefs.getInt('totalCigs') ?? 0;
      lastResetDate = DateTime.parse(
          prefs.getString('lastResetDate') ?? DateTime.now().toIso8601String());
      lastSmokeTime = DateTime.parse(
          prefs.getString('lastSmokeTime') ?? DateTime.now().toIso8601String());
      _updateValues();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('smokedToday', smokedToday);
    await prefs.setInt('totalCigs', totalCigs);
    await prefs.setString('lastResetDate', lastResetDate.toIso8601String());
    await prefs.setString('lastSmokeTime', lastSmokeTime.toIso8601String());
  }

  void _startTimers() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.day != lastResetDate.day) {
        setState(() {
          totalCigs += smokedToday;
          smokedToday = 0;
          lastResetDate = now;
          _updateValues();
          _saveData();
        });
      }
    });

    _lastSmokeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        Duration diff = DateTime.now().difference(lastSmokeTime);
        timeSinceLastSmoke = _formattedDuration(diff);
      });
    });
  }

  void increment() {
    setState(() {
      smokedToday++;
      lastSmokeTime = DateTime.now();
      _updateValues();
      _saveData();
    });
  }

  void decrement() {
    if (smokedToday > 0) {
      setState(() {
        smokedToday--;
        _updateValues();
        _saveData();
      });
    }
  }

  void _updateValues() {
    int cumulative = totalCigs + smokedToday;
    misspend = (cumulative * 20).toString();
    life = (cumulative * 11).toString();
    nic = (cumulative * 12).toString();
    cigsmk = cumulative.toString();
  }

  String _formattedDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    String result = "";

    // Add days if nonzero.
    if (days > 0) {
      result += "$days days";
    }

    // Add hours if nonzero.
    if (hours > 0) {
      if (result.isNotEmpty) result += ", ";
      result += "$hours hours";
    }

    // Always show minutes (or if days and hours are both zero, show minutes).
    if (result.isNotEmpty) {
      result += ", ";
    }
    result += "$minutes mins";

    result += " ago";
    return result;
  }


  @override
  void dispose() {
    _timer?.cancel();
    _lastSmokeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Track and Crack"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "You last smoked: ",
                    style: TextStyle(fontSize: 15, color: theme.colorScheme.primary),
                  ),
                  Text(
                    timeSinceLastSmoke,
                    style: TextStyle(fontSize: 15, color: theme.colorScheme.primary),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle,
                            size: 32, color: theme.iconTheme.color?.withValues()),
                        onPressed: decrement,
                      ),
                      Text(
                        "$smokedToday",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, size: 32, color: Colors.orange),
                        onPressed: increment,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Since you joined",
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
              ),
              SizedBox(height: screenHeight * 0.01),
              Center(
                child: Container(
                  width: screenWidth * 0.83,
                  height: screenHeight * 0.065,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Total cigarette smoked",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        "$cigsmk",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("₹$misspend", "Misspend", Icons.attach_money, screenWidth * 0.4),
                  infoCard("$cigsmk", "cigs smoked", Icons.smoke_free, screenWidth * 0.4),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("$life mins", "life reduced", Icons.favorite, screenWidth * 0.4),
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
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCardSmall("Doc", "Days Tracked", Icons.list),
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
    final theme = Theme.of(context);

    return Container(
      width: screenWidth * 0.5,
      height: screenHeight * 0.3,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 28),
          SizedBox(height: 5),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 3),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}