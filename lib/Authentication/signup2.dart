import 'package:airbound/Authentication/loginpage.dart';
import 'package:airbound/Home/home.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

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
    final double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    final double verticalPadding = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30),

                  /// **Email Field**
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please enter an email";
                      if (!GetUtils.isEmail(value)) return "Enter a valid email";
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  /// **Password Field**
                  Obx(() => TextFormField(
                    controller: passController,
                    obscureText: !isPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => isPasswordVisible.toggle(),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Please enter a password";
                      if (value.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  )),
                  const SizedBox(height: 30),

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
                                backgroundColor: Colors.green, colorText: Colors.white);
                            Get.offAll(() => Home());
                          }
                        } on FirebaseAuthException catch (e) {
                          Get.snackbar("Signup Error", e.message ?? "Something went wrong",
                              backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      }
                    },
                    buttonName: "Sign Up",
                    width: double.infinity,
                    height: 50.0,
                    clr: Colors.black,
                    txtclr: Colors.white,
                  ),
                  const SizedBox(height: 15),

                  /// **Login Redirect**
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Get.to(() => loginpage()),
                        child: const Text("Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
