import 'package:airbound/Authentication/loginpage.dart';
import 'package:airbound/Authentication/verificationScreen.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Theme/color_pallet.dart';
import '../controller/auth_controller.dart';

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  final AuthController controller = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width;
    final double verticalPadding = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Pallete.gradient1,Pallete.gradient2],
            end: Alignment.topRight,
            begin: Alignment.bottomLeft,),
        ),
        child: Center(
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

                    TextFormField(
                      controller: nameController,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Pallete.authButton),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Pallete.authButton, width: 1.0),
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
                      style: Theme.of(context).textTheme.bodySmall,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Pallete.authButton),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Pallete.authButton, width: 1.0),
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
                      style: Theme.of(context).textTheme.bodySmall,
                      obscureText: !isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Pallete.authButton),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Pallete.authButton, width: 1.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => isPasswordVisible.toggle(),
                          color: Pallete.authButton,
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

                            // Use the existing signUp method from AuthController
                            await controller.signUp(
                              email: emailController.text.trim(),
                              password: passController.text.trim(),
                              name: nameController.text.trim(),
                            );

                            // Close loading indicator
                            if (context.mounted) {
                              Navigator.pop(context);
                            }

                            // Navigate to verification screen
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VerificationScreen(),
                                ),
                              );
                            }
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
                      clr: Pallete.authButton,
                      txtclr: Colors.white,
                    ),
                    SizedBox(height: verticalPadding * 0.04),
                    /*Text("OR", style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: verticalPadding * 0.05),
                    commonButton(
                      onNavigate: () {},
                      buttonName: "Continue with Google",
                      width: horizontalPadding * 0.85,
                      height: verticalPadding * 0.07,
                      clr: Colors.white,
                      txtclr: Colors.black,
                    ),*/
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
      ),
    );
  }
}