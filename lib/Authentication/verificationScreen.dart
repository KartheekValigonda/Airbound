import 'dart:async';
import 'package:airbound/Authentication/additional_Info.dart';
import 'package:airbound/Theme/color_pallet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = FirebaseAuth.instance;
  final _authController = Get.find<AuthController>();
  User? user;
  Timer? _timer;
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _sendVerificationEmail();
    _startVerificationCheck();
  }

  Future<void> _sendVerificationEmail() async {
    try {
      if (user != null && !_emailSent) {
        await user!.sendEmailVerification();
        setState(() {
          _emailSent = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent successfully')),
          );
        }
      }
    } catch (e) {
      print('Error sending verification email: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending verification email: ${e.toString()}')),
        );
      }
    }
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        await user?.reload();
        user = _auth.currentUser;

        if (user?.emailVerified ?? false) {
          timer.cancel();
          if (mounted) {
            setState(() {
              _isLoading = true;
            });

            // Add a small delay to show the loading indicator
            await Future.delayed(const Duration(milliseconds: 500));

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdditionalInfo()),
              );
            }
          }
        }
      } catch (e) {
        print('Error checking verification status: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error checking verification status')),
          );
        }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.gradient1,
          title:  Text("Verify Your Email",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4e6655))),
          automaticallyImplyLeading: false, // Disable back button
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Pallete.gradient1,Pallete.gradient2],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A verification email has been sent',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Please check your mail inbox and verify your email.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    ElevatedButton(
                      onPressed: _emailSent ? _sendVerificationEmail : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.authButton,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(35),
                        ),
                        fixedSize: Size(screenWidth * 0.65, screenHeight * 0.065),
                      ),
                      child: Text(_emailSent ? 'Resend Email' : 'Sending...'),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}