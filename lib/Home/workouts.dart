import 'package:flutter/material.dart';

import '../Theme/color_pallet.dart';

class Workouts extends StatelessWidget {
  Workouts({super.key});

  final List<Exercise> cardioVascular = [
    Exercise(
      name: 'Brisk Walking/Jogging',
      icon: Icons.directions_walk_outlined,
      instructions:
      '~When: Morning or evening.\n~Duration: 20–30 minutes.\n~Benefits: Enhances circulation, increases lung capacity, and is gentle on joints.\n~Tip: Start with brisk walking, and gradually progress to jogging as your endurance improves.',
    ),
    Exercise(
      name: 'Cycling or Stationary Bike',
      icon: Icons.bike_scooter,
      instructions:
      '~When: Any time of the day.\n~Duration: 20–30 minutes.\n~Benefits: Low-impact activity that boosts cardiovascular health and can be done indoors or outdoors.',
    ),
    Exercise(
      name: 'Swimming',
      icon: Icons.water,
      instructions:
      'When: Ideal in warmer months or at an indoor pool.\n~Duration: 20–30 minutes.\n~Benefits: Works the entire body, improves lung capacity, and reduces stress on joints.',
    ),
    Exercise(
      name: 'High-Intensity Interval Training',
      icon: Icons.directions_run_outlined,
      instructions:
      'When: 2–3 times per week\nDuration: 15–20 minutes\nStructure: Short bursts (30 seconds) of high-intensity exercises (like sprinting, jumping jacks, or burpees) followed by a short recovery period.\nBenefits: Quickly boosts cardiovascular fitness and burns calories, which can help manage weight gain sometimes associated with quitting smoking.',
    ),
  ];

  final List<Exercise> strengthTraining = [
    Exercise(
      name: 'Push-Ups',
      icon: Icons.fitness_center,
      instructions:
      'Reps/Sets: 2–3 sets of 10–15 reps\nBenefits: Builds upper body strength and improves endurance.',
    ),
    Exercise(
      name: 'Squats & Lunges',
      icon: Icons.sports_hockey_rounded,
      instructions:
      'Reps/Sets: 2–3 sets of 15–20 reps per leg\nBenefits: Strengthens your lower body, improves balance, and helps maintain overall fitness.',
    ),
    Exercise(
      name: 'Planks',
      icon: Icons.man,
      instructions:
      'Duration: Hold for 30–60 seconds\nBenefits: Strengthens your core and helps with posture.',
    ),
    Exercise(
      name: 'Resistance Band Exercises',
      icon: Icons.sports,
      instructions:
      'When: As part of a circuit at home\nBenefits: Offers a low-impact way to build strength, which is helpful as your body adjusts to a smoke-free state.',
    ),
  ];

  final List<Exercise> mindfulnessExercises = [
    Exercise(
      name: 'Yoga',
      icon: Icons.sports_martial_arts_rounded,
      instructions:
      'Routine: Follow a 15–30 minute guided yoga session (many apps or YouTube channels offer sessions for beginners).\nBenefits: Increases lung capacity through deep, mindful breathing, reduces stress, and enhances overall well-being.',
    ),
    Exercise(
      name: 'Stretching',
      icon: Icons.sports_gymnastics_outlined,
      instructions:
      'Routine: Spend 5–10 minutes stretching after your workouts.\nBenefits: Improves flexibility and helps reduce muscle tension.',
    ),
    Exercise(
      name: 'Deep Breathing & Meditation',
      icon: Icons.air_outlined,
      instructions:
      'Routine: Practice diaphragmatic breathing or meditation for 5–10 minutes, especially during moments of craving.\nBenefits: Helps control the stress response and promotes relaxation. Techniques such as "4-7-8 breathing" (inhale for 4 seconds, hold for 7 seconds, exhale for 8 seconds) can be very effective.',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.032, vertical: screenHeight*0.02),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Text(
                    "Exercises to Help Quit Smoking",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Cardiovascular Exercises",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cardioVascular.length,
                      itemBuilder: (context, index) {
                        return exerciseCard(
                            exercise: cardioVascular[index], context: context);
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Strength Training & Bodyweight Exercises",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: strengthTraining.length,
                      itemBuilder: (context, index) {
                        return exerciseCard(
                            exercise: strengthTraining[index], context: context);
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Flexibility, Breathing, and Mindfulness Exercises",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: mindfulnessExercises.length,
                      itemBuilder: (context, index) {
                        return exerciseCard(
                            exercise: mindfulnessExercises[index], context: context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  class Exercise {
  final String name;
  final IconData icon;
  final String instructions;

  Exercise({
  required this.name,
  required this.icon,
  required this.instructions,
  });
  }
  Widget exerciseCard ({required Exercise exercise, required BuildContext context}){

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02, vertical: screenHeight*0.001),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          leading: Icon(
            exercise.icon,
            size: 30,
            color: Colors.teal,
          ),
          title: Text(
            exercise.name,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: screenHeight*0.01),
              child: Text(
                exercise.instructions,
                style: TextStyle(fontSize: 16,),
              ),
            ),
          ],
        ),
      ),
    );
  }
