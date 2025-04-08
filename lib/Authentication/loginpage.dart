import 'package:airbound/Authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commontextfield.dart';
import 'package:airbound/Home/home.dart';
import '../Theme/color_pallet.dart';
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
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Pallete.gradient1, Pallete.gradient2],
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: verticalPadding * 0.18),
              Text(
                "Login",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: verticalPadding * 0.08),
              commonTextfield(
                controller: controller.emailController,
                hinttext: "Email",
                obstxt: false,
                width: horizontalPadding * 0.85,
                height: verticalPadding * 0.07,
                context: context,
              ),
              SizedBox(height: verticalPadding * 0.015),
              commonTextfield(
                controller: controller.passController,
                hinttext: "Password",
                obstxt: true,
                width: horizontalPadding * 0.85,
                height: verticalPadding * 0.07,
                context: context,
              ),
              SizedBox(height: verticalPadding * 0.03),
              commonButton(
                onNavigate: () async {
                  UserCredential? userCredential =
                      await controller.loginMethod(context: context);
                  if (userCredential != null) {
                    Get.offAll(() => const Home());
                  }
                },
                buttonName: "Login",
                width: horizontalPadding * 0.85,
                height: verticalPadding * 0.07,
                clr: Pallete.authButton,
                txtclr: Colors.white,
              ),
              SizedBox(height: verticalPadding * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 0.12),
                child: Divider(
                  height: 1,
                  color: Pallete.authButton,
                ),
              ),
              Text(
                "OR",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: verticalPadding * 0.04),
              commonButton(
                onNavigate: () {
                  // Google Sign-in logic here
                },
                buttonName: "Continue with Google",
                width: horizontalPadding * 0.85,
                height: verticalPadding * 0.07,
                clr: Colors.white,
                txtclr: Colors.black,
              ),
              SizedBox(height: verticalPadding * 0.04),
              GestureDetector(
                onTap: () {
                  Get.off(() => const Signup2());
                },
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account!!",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: "  SignUp",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
