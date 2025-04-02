import 'package:airbound/Authentication/loginpage.dart';
import 'package:airbound/Authentication/verificationScreen.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../services/firestore_service.dart';
import 'dart:math' as math;

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  final AuthController controller = Get.put(AuthController());
  final FirestoreService _firestoreService = FirestoreService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;

  // **Firebase Instance**
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width;
    final double verticalPadding = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: verticalPadding * 0.25,
              right: horizontalPadding * 0.1,
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: Container(
                  width: horizontalPadding * 2,
                  height: horizontalPadding * 2.1,
                  color: const Color(0xFF006A67),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.07,
                        vertical: verticalPadding * 0.05),
                    child: Column(
                      children: [
                        SizedBox(height: verticalPadding * 0.02),
                        Text(
                          "Sign Up",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: verticalPadding * 0.09),

                        /// **Name Field**
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white60),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Please enter your name";
                            return null;
                          },
                        ),
                        SizedBox(height: verticalPadding * 0.018),

                        /// **Email Field**
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white60),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return "Please enter an email";
                            if (!GetUtils.isEmail(value))
                              return "Enter a valid email";
                            return null;
                          },
                        ),
                        SizedBox(height: verticalPadding * 0.018),

                        /// **Password Field**
                        Obx(() => TextFormField(
                              controller: passController,
                              obscureText: !isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: Theme.of(context).textTheme.bodyMedium,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white60),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () => isPasswordVisible.toggle(),
                                  color: Colors.teal,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return "Please enter a password";
                                if (value.length < 6)
                                  return "Password must be at least 6 characters";
                                return null;
                              },
                            )),
                        SizedBox(height: verticalPadding * 0.05),

                        /// **Sign Up Button**
                        commonButton(
                          onNavigate: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );

                                // Create user account
                                final UserCredential userCredential =
                                    await _auth.createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passController.text.trim(),
                                );

                                if (userCredential.user != null) {
                                  // Store user data in Firestore
                                  await _firestoreService.createUserDocument(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                  );

                                  // Close loading indicator
                                  Navigator.pop(context);

                                  // Show success message
                                  Get.snackbar(
                                    "Success",
                                    "Account created successfully!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );

                                  // Navigate to verification screen
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerificationScreen(),
                                      ),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                // Close loading indicator
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }

                                String errorMessage = "Something went wrong";
                                switch (e.code) {
                                  case 'weak-password':
                                    errorMessage = "The password provided is too weak.";
                                    break;
                                  case 'email-already-in-use':
                                    errorMessage = "An account already exists for this email.";
                                    break;
                                  case 'invalid-email':
                                    errorMessage = "The email address is invalid.";
                                    break;
                                  default:
                                    errorMessage = e.message ?? "Something went wrong";
                                }

                                // Show error message
                                Get.snackbar(
                                  "Signup Error",
                                  errorMessage,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                // Close loading indicator
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }

                                // Show error message
                                Get.snackbar(
                                  "Error",
                                  "An unexpected error occurred: $e",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          buttonName: "Sign Up",
                          width: horizontalPadding * 0.9,
                          height: verticalPadding * 0.07,
                          clr: Color(0xFF006A67),
                          txtclr: Colors.white,
                        ),
                        SizedBox(height: verticalPadding * 0.04),
                        Text("OR", style: Theme.of(context).textTheme.bodySmall),
                        SizedBox(height: verticalPadding * 0.05),
                        commonButton(
                          onNavigate: () {},
                          buttonName: "Continue with Google",
                          width: horizontalPadding * 0.85,
                          height: verticalPadding * 0.07,
                          clr: Colors.white,
                          txtclr: Colors.black,
                        ),
                        SizedBox(height: verticalPadding * 0.03),
                        InkWell(
                          child: Text("Already have an account! LogIn"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                        )
                      ],
                    ),
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
