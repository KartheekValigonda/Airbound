import 'package:airbound/Authentication/signup2.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commontextfield.dart';
import 'package:airbound/Home/home.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var controller = Get.put(AuthController());

  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width;
    final verticalPadding = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(children: [
          Positioned(
            top: verticalPadding * 0.25, // Adjust negative offset as needed
            right: horizontalPadding * 0.1,
            child: Transform.rotate(
              angle: 45 * math.pi / 180, // 45 degree rotation
              child: Container(
                width: horizontalPadding * 2, // Adjust size as needed
                height: horizontalPadding * 2.1,
                color: const Color(0xFF006A67), // Green container (hex code)
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: verticalPadding * 0.18),
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: verticalPadding * 0.08,
                ),
                commonTextfield(
                  controller: controller.emailController,
                  hinttext: "Email",
                  obstxt: false,
                  width: horizontalPadding * 0.85,
                  height: verticalPadding * 0.07,
                ),
                SizedBox(
                  height: verticalPadding * 0.015,
                ),
                commonTextfield(
                  controller: controller.passController,
                  hinttext: "Password",
                  obstxt: true,
                  width: horizontalPadding * 0.85,
                  height: verticalPadding * 0.07,
                ),
                SizedBox(height: verticalPadding * 0.03),
                commonButton(
                  onNavigate: () async {
                    UserCredential? userCredential = await controller.loginMethod(context: context);
                    if (userCredential != null) {
                      Get.offAll(() => Home());
                    }
                  },
                  buttonName: "login",
                  width: horizontalPadding * 0.85,
                  height: verticalPadding * 0.07,
                  clr: Color(0xFF006A67),
                  txtclr: Colors.white,
                ),
                SizedBox(height: verticalPadding * 0.04),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding * 0.12),
                  child: Divider(height: 1,),
                ),
                Text(
                  "OR",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: verticalPadding * 0.04),
                commonButton(
                  onNavigate: () {},
                  buttonName: "Continue with Google",
                  width: horizontalPadding * 0.85,
                  height: verticalPadding * 0.07,
                  clr: Colors.white,
                  txtclr: Colors.black,
                ),

                SizedBox(height: verticalPadding*0.04),
                GestureDetector(
                  onTap: () {
                    Get.off(()=> Signup2());
                  },
                  child: RichText(
                    text: TextSpan(text: "Don't have an account!!",style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(text:"  SignUp",  style: Theme.of(context).textTheme.titleMedium,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
