import 'package:airbound/Home/home.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'dart:math' as math;


class Signup2 extends StatelessWidget {
  Signup2({super.key});

  final AuthController controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;

  // **Firebase Instance**
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width ;
    final double verticalPadding = MediaQuery.of(context).size.height ;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        child: Stack(
          children:[
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
            Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding*0.07,vertical: verticalPadding*0.05),
                  child: Column(
                    children: [
                      SizedBox(height: verticalPadding*0.02),
                      const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: verticalPadding*0.09),

                      /// **Email Field**
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white60), // Border color when enabled
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 1.0), // Border color when focused
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter an email";
                          if (!GetUtils.isEmail(value)) return "Enter a valid email";
                          return null;
                        },
                      ),
                      SizedBox(height: verticalPadding*0.018),

                      /// **Password Field**
                      Obx(() => TextFormField(
                        controller: passController,
                        obscureText: !isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white60), // Border color when enabled
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 1.0), // Border color when focused
                            borderRadius: BorderRadius.circular(30),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => isPasswordVisible.toggle(),
                            color: Colors.teal,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter a password";
                          if (value.length < 6) return "Password must be at least 6 characters";
                          return null;
                        },
                      )),
                      SizedBox(height: verticalPadding*0.05),

                      /// **Sign Up Button**
                      commonButton(
                        onNavigate: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // **Sign Up the User**
                              final UserCredential userCredential =
                              await _auth.createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passController.text.trim(),
                              );

                              if (userCredential.user != null) {
                                Get.snackbar("Success", "Account created successfully!",
                                    backgroundColor: Colors.teal, colorText: Colors.white);
                                Get.offAll(() => Home());
                              }
                            } on FirebaseAuthException catch (e) {
                              Get.snackbar("Signup Error", e.message ?? "Something went wrong",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          }
                        },
                        buttonName: "Sign Up",
                        width: horizontalPadding*0.9,
                        height: verticalPadding*0.07,
                        clr: Color(0xFF006A67),
                        txtclr: Colors.white,
                      ),
                      SizedBox(height:verticalPadding*0.04),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding*0.12),
                        child: Divider(height: 1,),
                      ),
                      Text("OR", style: TextStyle(fontSize: 18,),),
                      SizedBox(height: verticalPadding*0.05),
                      commonButton(
                        onNavigate: (){},
                        buttonName: "Continue with Google",
                        width: horizontalPadding*0.85,
                        height: verticalPadding*0.07,
                        clr: Colors.white,
                        txtclr: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
        ),
      ),
    );
  }
}
