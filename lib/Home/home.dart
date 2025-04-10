import 'dart:async';
import 'package:airbound/Home/Start_here.dart';
import 'package:airbound/Home/second_slide.dart';
import 'package:airbound/Home/some_ques.dart';
import 'package:airbound/Home/whyquit.dart';
import 'package:airbound/Home/workouts.dart';
import 'package:airbound/Progress/progress.dart';
import 'package:airbound/Recovery/recovery.dart';
import 'package:airbound/Theme/color_pallet.dart';
import 'package:airbound/User/profile.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commonCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
    Recovery(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Pallete.gradient1,
        buttonBackgroundColor: Pallete.authButton,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Pallete.backgroundColor),
          Icon(Icons.show_chart, color: Pallete.backgroundColor),
          Icon(Icons.monitor_heart_outlined, color: Pallete.backgroundColor),
          Icon(Icons.person, color: Pallete.backgroundColor),
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
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Pallete.gradient1,Pallete.gradient2],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.12),
                Text("A New", style: theme.textTheme.titleLarge),
                Text("Journey Begins", style: theme.textTheme.titleLarge),
                SizedBox(height: screenHeight * 0.025),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02, vertical: screenHeight*0.02),
                  decoration: BoxDecoration(
                    color: Pallete.bigCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "You last smoked: ",
                        style: theme.textTheme.bodySmall
                      ),
                      Text(
                        timeSinceLastSmoke,
                        style: theme.textTheme.bodySmall
                      ),
                      Text(
                        "Keep it Up!! Continue The Streak",
                        style: theme.textTheme.bodySmall
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
                        txtclr: Colors.black,
                        clr: Colors.white70,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Text(
                    "Introduction",
                      style: theme.textTheme.bodyLarge
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  "Modules",
                    style: theme.textTheme.bodyMedium
                ),
                SizedBox(height: screenHeight * 0.015),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => WelcomeScreen())),
                        child: commonCard(
                          text: "START HERE: Welcome to QuitSure",
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.001,
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Needtoquit())),
                        child: commonCard(
                          text: "But Do I Really Need to Quit Smoking",
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.001,
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SomeQues())),
                        child: commonCard(
                          text: "Some Important Questions",
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.001,
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Exercises",
                    style: theme.textTheme.bodyMedium
                ),
                SizedBox(height: screenHeight * 0.02),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Whyquit())),
                        child: commonCard(
                          text: "Why I Want to Quit",
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.001,
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Workouts())),
                        child: commonCard(
                          text: "Quitting is Enjoyable",
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.001,
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.2,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}