import 'package:airbound/Home/home.dart';
import 'package:airbound/Theme/theme.dart';
import 'package:airbound/openingpg.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirBound',
      theme: AppThemes.appTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(), // Set the splash screen as the initial screen.
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController with a 2-second duration.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    // Use a curved animation with bounce effect.
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    // Start the animation.
    _controller.forward();

    // Delay for 3 seconds before navigating to the opening page.
    Future.delayed(const Duration(seconds: 3), () {
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null){
        Get.offAll(()=> Home());
      }else{
        Get.offAll(() => openingpg());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006A67),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Interpolate the alignment from the top-center to the center.
          Alignment alignment = Alignment.lerp(Alignment.topCenter, Alignment.center, _animation.value)!;
          return Align(
            alignment: alignment,
            child: child,
          );
        },
        child: const Text('AirBound', style: TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold,),
        ),
      ),
    );
  }
}
