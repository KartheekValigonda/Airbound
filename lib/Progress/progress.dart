import 'dart:async';
import 'package:airbound/common%20widgets/infocard.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'chart_widget.dart'; // Adjust path based on your project structure

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  int smokedToday = 0;
  int totalCigs = 0;
  DateTime lastResetDate = DateTime.now();
  DateTime lastSmokeTime = DateTime.now();

  String misspend = "0";
  String cigsmk = "0";
  String life = "0";
  String nic = "0";
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

    if (days > 0) result += "$days days";
    if (hours > 0) {
      if (result.isNotEmpty) result += ", ";
      result += "$hours hours";
    }
    if (result.isNotEmpty) result += ", ";
    result += "$minutes mins ago";
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

    int daysSinceReset = DateTime.now().difference(lastResetDate).inDays + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Track and Crack"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.03),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("You last smoked: ", style: theme.textTheme.bodySmall),
                  Text(timeSinceLastSmoke, style: theme.textTheme.bodySmall),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.02),
                  decoration: BoxDecoration(
                    color: Color(0xFF006A67),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text("Today, You have smoked"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle,
                                size: 26, color: theme.iconTheme.color),
                            onPressed: decrement,
                          ),
                          Text(
                            "$smokedToday",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle,
                                size: 26, color: Colors.black),
                            onPressed: increment,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text("Since you joined", style: theme.textTheme.bodyMedium),
              SizedBox(height: screenHeight * 0.01),
              Center(
                child: Container(
                  width: screenWidth * 0.87,
                  height: screenHeight * 0.065,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Total cigarette smoked",
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Text("$cigsmk", style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("₹$misspend", "Misspend", Icons.attach_money,
                      screenWidth * 0.42, screenHeight * 0.15),
                  infoCard("$cigsmk", "cigs smoked", Icons.smoke_free,
                      screenWidth * 0.42, screenHeight * 0.15),
                ],
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoCard("$life mins", "life reduced", Icons.favorite,
                      screenWidth * 0.42, screenHeight * 0.15),
                  infoCard("$nic mg", "Nicotine Consumed", Icons.bubble_chart,
                      screenWidth * 0.42, screenHeight * 0.15),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Card(
                child: SizedBox(
                  height: screenHeight * 0.5,
                  child: buildChart("Cigarettes Smoked", double.parse(cigsmk),
                      ChartMetric.cigarettes, daysSinceReset, context),
                ),
              ),
              Card(
                child: SizedBox(
                  height: screenHeight * 0.5,
                  child: buildChart("Money Spent", double.parse(misspend),
                      ChartMetric.money, daysSinceReset, context),
                ),
              ),
              Card(
                child: SizedBox(
                  height: screenHeight * 0.5,
                  child: buildChart("Nicotine Consumed", double.parse(nic),
                      ChartMetric.nicotine, daysSinceReset, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}