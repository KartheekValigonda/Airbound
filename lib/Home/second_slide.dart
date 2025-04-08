import 'package:airbound/Home/home.dart';
import 'package:airbound/Theme/color_pallet.dart';
import 'package:flutter/material.dart';

class Needtoquit extends StatefulWidget {
  const Needtoquit({super.key});

  @override
  State<Needtoquit> createState() => _NeedtoquitState();
}

class _NeedtoquitState extends State<Needtoquit> {
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
              children: List.generate(2, (index) {
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
            'The Health Risks of Smoking',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Smoking is a leading cause of preventable deaths worldwide. It increases the risk of lung cancer, heart disease, stroke, and respiratory issues. According to the World Health Organization (WHO), quitting smoking can significantly reduce these risks and improve your overall health.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.06),
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
            "Let's do it together",
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            "Quitting smoking is challenging, but the benefits are worth it. You'll save money, improve your lung function, and set a positive example for others. Every day without smoking is a step toward a healthier, happier life!",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.06),
          ElevatedButton(
            onPressed: () {
              // Navigate to the main app screen (e.g., Home) after pledge
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home())); // Adjust route
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1, vertical: 15),
              backgroundColor: Pallete.authButton,
              foregroundColor: Colors.white,
            ),
            child: const Text("Let's go"),
          ),
        ],
      ),
    );
  }
}