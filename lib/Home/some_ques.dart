import 'package:flutter/material.dart';

import '../Theme/color_pallet.dart';

class SomeQues extends StatelessWidget {
  const SomeQues({super.key});

  final List<Map<String, String>> qaList = const [
    {
      'question': 'Why did I start smoking in the first place?',
      'answer':"Many start due to stress, peer pressure, or curiosity. Recognizing this helps me see it's not a need but a habit I can break.",
      'imageUrl': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
    },
    {
      'question': 'How does smoking affect my health?',
      'answer':
      'It damages lungs, heart, and skin while increasing cancer risk. Quitting can reverse some effects and boost my vitality.',
      'imageUrl': 'https://images.unsplash.com/photo-1618477241190-663d4e97b439?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // New: Healthy lungs concept
    },
    {
      'question': 'What will I gain financially by quitting?',
      'answer': "A pack-a-day habit costs hundreds yearly. That's money for vacations, hobbies, or savings instead of smoke.",
      'imageUrl': "https://images.unsplash.com/photo-1556740714-5d4e4f07f7e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80", // New: Money saving
    },
    {
    'question': 'How will my relationships improve?',
    'answer': "No more smoky smell or health worries for loved ones. I'll feel more present and connected.",
    'imageUrl': 'https://images.unsplash.com/photo-1529336953128-a85760f58cb5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // Original (still works)
    },
    {
      'question': 'What about withdrawal symptoms?',
      'answer': "They're temporary—cravings peak in days and fade in weeks. I'll feel stronger each day I push through.",
      'imageUrl': 'https://images.unsplash.com/photo-1597854658468-596b5a6e6e32?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // New: Strength and resilience
    },
    {
      'question': 'How will my daily energy change?',
      'answer': 'Smoking drains oxygen. Quitting boosts stamina, making exercise and daily tasks easier and more enjoyable.',
      'imageUrl': 'https://images.unsplash.com/photo-1557339352-0056e73f1bd9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // New: Active lifestyle
    },
    {
    'question': 'Can quitting improve my mental health?',
    'answer': 'Yes! It reduces anxiety over time, improves mood, and breaks the cycle of nicotine dependence.',
    'imageUrl': 'https://images.unsplash.com/photo-1506126611910-1ae2ced8436d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80', // Original (still works)
    },
    {
      'question': 'How will my senses improve?',
      'answer': "Taste and smell dull with smoking. Quitting brings back flavors and scents I've missed—like fresh coffee or flowers.",
      'imageUrl': "https://images.unsplash.com/photo-1517248135467-2c0b8b15d9c9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80", // New: Coffee and senses
    },
    {
      'question': 'Why is now the right time to quit?',
      'answer':
      'Every day smoking steals from my future. Starting now means a healthier, happier me sooner.',
      'imageUrl':
      'https://images.unsplash.com/photo-1505455184862-554165e5f6ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
    },
  ];

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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.12),
              Text(
                'Quit Smoking Q&A',
                style: theme.textTheme.titleLarge
              ),
              SizedBox(height: screenHeight * 0.02),
              // Header Image
              Container(
                width: double.infinity,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1505455184862-554165e5f6ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Title
              Text(
                'Key Questions About Quitting Smoking',
                  style: theme.textTheme.bodyLarge
              ),
              SizedBox(height: screenHeight * 0.015),

              // Introduction Text
              Text(
                "Here are some vital questions I've asked myself about quitting smoking—and the answers that keep me motivated!",
                  style: theme.textTheme.bodySmall
              ),
              SizedBox(height: screenHeight * 0.025),

              // Q&A Expansion Tiles
              ...qaList.map((qa) => _buildQuestionTile(
                context,
                question: qa['question']!,
                answer: qa['answer']!,
                imageUrl: qa['imageUrl']!,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              )).toList(),

              SizedBox(height: screenHeight * 0.025),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTile(
      BuildContext context, {
        required String question,
        required String answer,
        required String imageUrl,
        required double screenWidth,
        required double screenHeight,
      }) {

    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: screenHeight * 0.015), // Dynamic margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: ExpansionTile(
        title: Text(
          question,
            style: theme.textTheme.bodyMedium
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  child: Image.network(
                    imageUrl,
                    height: screenHeight * 0.15, // 15% of screen height
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  answer,
                    style: theme.textTheme.bodySmall
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}