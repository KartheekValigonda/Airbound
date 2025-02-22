import 'dart:async';
import 'package:airbound/Home/Start_here.dart';
import 'package:airbound/Home/second_slide.dart';
import 'package:airbound/Home/workouts.dart';
import 'package:airbound/Progress/progress.dart';
import 'package:airbound/To-Dos/dailytask.dart';
import 'package:airbound/User/profile.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commonCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    Progress(),
    Dailytask(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        // Theme properties are applied via BottomNavigationBarThemeData
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.checklist_rounded), label: "To-Dos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String timeSinceLastSmoke = "0 minutes, 0 hours, 0 days";
  DateTime lastSmokeTime = DateTime.now();
  Timer? _lastSmokeTimer;

  @override
  void initState() {
    super.initState();
    _loadLastSmokeTime();
    _startTimer();
  }

  Future<void> _loadLastSmokeTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastSmokeTime = DateTime.parse(
          prefs.getString('lastSmokeTime') ?? DateTime.now().toIso8601String());
      _updateTimeSinceLastSmoke();
    });
  }

  void _startTimer() {
    _lastSmokeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _updateTimeSinceLastSmoke();
      });
    });
  }

  void _updateTimeSinceLastSmoke() {
    Duration diff = DateTime.now().difference(lastSmokeTime);
    timeSinceLastSmoke = _formattedDuration(diff);
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
    _lastSmokeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context); // Access theme data

    return Scaffold(
      appBar: AppBar(
        title: const Text("Airbound"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("A New", style: theme.textTheme.headlineSmall),
              Text("Journey Begins", style: theme.textTheme.headlineSmall),
              SizedBox(height: screenHeight * 0.025),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02, vertical: screenHeight*0.02),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary, // Use secondary color from theme
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "You last smoked: ",
                      style: TextStyle(
                          fontSize: 18, color: theme.colorScheme.primary),
                    ),
                    Text(
                      timeSinceLastSmoke,
                      style: TextStyle(
                          fontSize: 15, color: theme.colorScheme.primary),
                    ),
                    Text(
                      "Keep it Up!! Continue The Streak",
                      style: TextStyle(
                          fontSize: 15, color: theme.colorScheme.primary),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    commonButton(
                      onNavigate: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Progress()),
                        );
                      },
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.04,
                      buttonName: "Track Your Progress",
                      txtclr: theme.colorScheme.primary,
                      clr: theme.elevatedButtonTheme.style?.backgroundColor
                          ?.resolve({}) ??
                          Colors.teal,
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  "Introduction",
                  style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                "Modules",
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
              ),
              SizedBox(height: screenHeight * 0.015),

              GestureDetector(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => WelcomeScreen())),
                child: commonCard(
                  text: "START HERE: Welcome to QuitSure",
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.01,
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Needtoquit())),
                child: commonCard(
                  text: "But Do I Really Need to Quit Smoking",
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.01,
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "Some Important Questions",
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.01,
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Exercises",
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "Why I Want to Quit",
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.01,
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Workouts())),
                child: commonCard(
                  text: "Quitting is Enjoyable",
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.01,
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}