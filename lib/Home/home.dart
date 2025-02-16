import 'package:airbound/Progress/progress.dart';
import 'package:airbound/To-Dos/dailytask.dart';
import 'package:airbound/User/profile.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commonCard.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0; // Track the selected tab

  final List<Widget> _pages = [
    HomeScreen(),
    Progress(),
    Dailytask(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Change tab
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Airbound",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF006A67), // Set background color to black
        iconTheme: const IconThemeData(color: Colors.white), // Change back button and icons to white
        centerTitle: true, // Center the title text
      ),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("A New", style: TextStyle(fontSize: 35)),
              const Text("Journey Begins", style: TextStyle(fontSize: 35)),
              SizedBox(height: screenHeight * 0.025),

              // 🟢 Smoke Tracker Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.01), // Add spacing
                    Center(
                      child: commonButton(
                        onNavigate: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Progress()), // Change to your actual progress page
                          );
                        },
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.04,
                        buttonName: "Track Your Progress", // 🔴 Fixed Typo
                        txtclr: Colors.teal,
                        clr: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              const Center(
                child: Text("Introduction", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: screenHeight * 0.005),
              const Text("Modules", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: screenHeight * 0.015),

              // 🟢 Fixed CommonCard (Added Required Properties)
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "START HERE: Welcome to QuitSure",
                  horizontal: screenWidth * 0.01, // 🟢 Required Parameter
                  vertical: screenHeight * 0.01,   // 🟢 Required Parameter
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11, // Increased for Visibility
                ),
              ),

              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "This Time it's Different",
                  horizontal: screenWidth * 0.01, // 🟢 Required Parameter
                  vertical: screenHeight * 0.01,   // 🟢 Required Parameter
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "But Do I Really Need to Quit Smoking",
                  horizontal: screenWidth * 0.01, // 🟢 Required Parameter
                  vertical: screenHeight * 0.01,   // 🟢 Required Parameter
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "Some Important Questions",
                  horizontal: screenWidth * 0.01, // 🟢 Required Parameter
                  vertical: screenHeight * 0.01,   // 🟢 Required Parameter
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              SizedBox(height: screenHeight*0.02),
              const Text("Exercises", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: screenHeight*0.02),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "Why I Want to Quit",
                  horizontal: screenWidth * 0.01, // 🟢 Required Parameter
                  vertical: screenHeight * 0.01,   // 🟢 Required Parameter
                  width: screenWidth * 0.88,
                  height: screenHeight * 0.11,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Placeholder())),
                child: commonCard(
                  text: "Quitting is Enjoyable",
                  horizontal: screenWidth * 0.01, // 🟢 Required Parameter
                  vertical: screenHeight * 0.01,   // 🟢 Required Parameter
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



