import 'package:airbound/Theme/color_pallet.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/Authentication/info.dart';
import 'package:airbound/Authentication/loginpage.dart';
import 'package:flutter/material.dart';

class OpeningPg extends StatefulWidget {
  const OpeningPg({super.key});

  @override
  State<OpeningPg> createState() => _OpeningPgState();
}

class _OpeningPgState extends State<OpeningPg> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width;
    final verticalPadding = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            // Container with gradient background
            Center(
              child: Container(
                height: verticalPadding*0.6,
                width: horizontalPadding*0.9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Pallete.gradient1, Pallete.gradient2],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(height: verticalPadding*0.1),
                    const Text(
                      "Welcome to a healthier life.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Start your journey towards freedom from smoking and regain more time and health",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                    SizedBox(height: verticalPadding*0.06),
                    commonButton(
                      onNavigate: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Info()));
                      },
                      buttonName: "Let's get started!",
                      width: horizontalPadding*0.8,
                      height: verticalPadding*0.06,
                      clr: Pallete.authButton
                    ),
                    SizedBox(height: verticalPadding*0.02),
                    commonButton(
                      onNavigate: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                      buttonName: "I already have an account",
                      width: horizontalPadding*0.8,
                      height: verticalPadding*0.06,
                      txtclr: Colors.black
                    ),
                  ],
                ),
              ),
            ),
            
            // Logo positioned above the container
            Positioned(
              top: verticalPadding * 0.12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: horizontalPadding * 0.35,
                  height: horizontalPadding * 0.35,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
