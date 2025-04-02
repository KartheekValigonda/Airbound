import 'package:flutter/material.dart';

import '../Theme/color_pallet.dart';

class Whyquit extends StatelessWidget {
  const Whyquit({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsive sizing if needed
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            child: Container(
              height: screenHeight*0.28,
              child: Center(child: Text("")),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Pallete.gradient1,Pallete.gradient2]),
                  borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04 ,vertical: screenHeight*0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.12),
                Text(
                  'Why Quit Smoking?',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                // Header Image
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1505455184862-554165e5f6ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.03),

                // Title
                const Text(
                  'My Journey to Quit Smoking',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: screenHeight*0.02),

                // Introduction Text
                const Text(
                  "Smoking was once a part of my daily routine, but I decided it's time for a change. Here's why I want to quit and why you should too!",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: screenHeight*0.02),

                // Reason 1: Health Benefits
                _buildReasonCard(
                  context,
                  title: '1. Better Health',
                  description:
                  'Quitting smoking reduces the risk of heart disease, lung cancer, and stroke. Within weeks, your breathing improves, and your energy levels soar!',
                  imageUrl:
                  'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                ),
                SizedBox(height: screenHeight*0.02),

                // Reason 2: Save Money
                _buildReasonCard(
                  context,
                  title: '2. Save Money',
                  description:
                  'Think about it: a pack a day can cost hundreds monthly. Quitting means more money for things you love—like travel or hobbies.',
                  imageUrl:
                  'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                ),
                SizedBox(height: screenHeight*0.02),

                // Reason 3: Improved Relationships
                _buildReasonCard(
                  context,
                  title: '3. Stronger Relationships',
                  description: "No more smoky smell on clothes or breath. Your loved ones will thank you, and you'll feel more confident in social settings.",
                  imageUrl:
                  'https://images.unsplash.com/photo-1511632765486-a01980e01a18?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                ),
                SizedBox(height: screenHeight*0.02),

                // Motivational Quote
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02, vertical: screenHeight*0.02),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '"The best way to stop smoking is to just stop—no ifs, ands, or butts." - Anonymous',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02),

                // Call to Action
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("You've got this! Start today!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Take the First Step',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonCard(
      BuildContext context, {
        required String title,
        required String description,
        required String imageUrl,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03), // Dynamic radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(screenWidth * 0.03), // Dynamic top radius
            ),
            child: Image.network(
              imageUrl,
              height: screenHeight * 0.2, // 20% of screen height
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.055, // Dynamic font size (~20 on avg screen)
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Dynamic font size (~16 on avg screen)
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

