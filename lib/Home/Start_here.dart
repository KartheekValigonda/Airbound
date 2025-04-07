import 'package:airbound/Progress/progress.dart';
import 'package:flutter/material.dart';

import '../Theme/color_pallet.dart' show Pallete;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              _buildWelcomePage(theme, screenWidth, screenHeight),
              _buildInstructionsPage(theme, screenWidth, screenHeight),
              _buildPledgePage(theme, screenWidth, screenHeight),
            ],
          ),
          // Navigation Dots
          Positioned(
            bottom: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentPage == index ? 12.0 : 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Pallete.authButton
                        : Pallete.gradient1,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Welcome Page
  Widget _buildWelcomePage(
      ThemeData theme, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, vertical: screenHeight * 0.1),
      color: Pallete.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.smoke_free,
            size: 100,
            color: Pallete.authButton,
          ),
          SizedBox(height: screenHeight * 0.04),
          Text(
            "Welcome to Airbound",
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            "Your journey to a smoke-free life begins now! Airbound provides the support, tracking, and motivation you need to quit smoking. Stay committed, monitor progress, and embrace a healthier lifestyle with our guidance. Take the first step toward a smoke-free, healthier you today!",
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.06),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child:  Text("Get Started",
            style: TextStyle(
              color: Pallete.authButton
            ),),
          ),
        ],
      ),
    );
  }

  // Instructions Page
  Widget _buildInstructionsPage(
      ThemeData theme, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, vertical: screenHeight * 0.1),
      color: Pallete.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ditching tobacco is a easy journey",
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: screenHeight * 0.03),
          _buildInstructionItem(
            theme,
            "Set a Quit Date",
            "Today is the best day. Taking action and staying committed builds success and confidence!",
          ),
          _buildInstructionItem(
            theme,
            "Identify Triggers",
            "Recognize situations that make you want to smoke and plan alternatives.",
          ),
          _buildInstructionItem(
            theme,
            "Seek Support",
            "Tell friends, family, or join a support group for encouragement.",
          ),
          _buildInstructionItem(
            theme,
            "Stay Positive",
            "Focus on the benefits—like better health and saving money.",
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                      color: Pallete.authButton
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child:  Text("Next",
                  style: TextStyle(
                    color: Pallete.authButton
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Pledge Page
  Widget _buildPledgePage(
      ThemeData theme, double screenWidth, double screenHeight) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06, vertical: screenHeight * 0.1),
      color: Pallete.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Take A Pledge With Me",
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            "I pledge to quit smoking and live a healthier, smoke-free life. With determination, I embrace a fresh start for better health and vitality.",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.06),
          ElevatedButton(
            onPressed: () {
              // Navigate to the main app screen (e.g., Home) after pledge
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Progress())); // Adjust route
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, vertical: 15),
              backgroundColor: Pallete.authButton,
              foregroundColor: Colors.white,
            ),
            child: const Text("I Pledge to Quit"),
          ),
        ],
      ),
    );
  }

  // Helper method for instruction items
  Widget _buildInstructionItem(ThemeData theme, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color:Pallete.authButton, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}