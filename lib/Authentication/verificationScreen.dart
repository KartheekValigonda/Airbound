import 'dart:async';
import 'package:airbound/Authentication/additional_Info.dart';
import 'package:airbound/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = FirebaseAuth.instance;
  User? user;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await user?.reload();
      user = _auth.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdditionalInfo()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width ;
    final screenHeight = MediaQuery.of(context).size.height ;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006A67),
        title: Text("Verify Your Email",),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A verification email has been sent', style: Theme.of(context).textTheme.bodyLarge,),
            SizedBox(height: screenHeight*0.02),
            Text('Please check your mail inbox and verify your email.',style: Theme.of(context).textTheme.bodyMedium,),
            SizedBox(height: screenHeight*0.1),
            ElevatedButton(
              onPressed: () async {
                await user?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Verification email resent.')),
                );
              },
              child: Text('Resend Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white, // Text color
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Colors.white
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                fixedSize: Size(screenWidth*0.65, screenHeight*0.065)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
