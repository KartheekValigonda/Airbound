import 'package:airbound/Authentication/signup1.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Info> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _pages = [
    {
      "image": "assets/images/pg1.png",
      "title": "Become a non-smoker in a short time",
      "subtitle": "With airbound, you can overcome the most difficult phase of addiction, after that you won't want to go back."
    },
    {
      "image": "assets/images/pg2.png",
      "title": "The beginning of a transformation journey",
      "subtitle": "On the way to a smoke-free future, you will learn a lot about yourself, gain strength and enjoy a healthy life."
    },
    {
      "image": "assets/images/p3.png",
      "title": "Seize your chance",
      "subtitle": "The best moment is now. Start today and take control of your life."
    },
  ];

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }


  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Signup1()),
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 16 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.redAccent : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      body: Container(
        color: _currentPage == _pages.length - 1 ? Colors.black : Colors.white, // Conditional background color
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    final isLastPage = index == _pages.length - 1;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            page["image"]!,
                            height: screenHeight * 0.3,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Text(
                            page["title"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isTablet ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: isLastPage ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                            ),
                            child: Text(
                              page["subtitle"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                                color: isLastPage ? Colors.grey[300] : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => _buildDot(index == _currentPage),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _onNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentPage == _pages.length - 1
                          ? Colors.white
                          : Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 60 : 50,
                        vertical: isTablet ? 18 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? "Finish" : "Next",
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: _currentPage == _pages.length - 1
                            ? Color(0xFF006A67)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

