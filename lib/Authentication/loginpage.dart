import 'dart:ui';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commontextfield.dart';
import 'package:airbound/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  var controller = Get.put(AuthController());

  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width ;
    final verticalPadding = MediaQuery.of(context).size.height ;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: verticalPadding*0.1),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(32), // Optional: Rounded corners
                  ),
                ),
              ),
              const Text("Login",style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),),
              SizedBox(height: verticalPadding*0.03,),
              commonTextfield(
                controller: controller.emailController,
                hinttext: "Email",
                obstxt: false,
                width: horizontalPadding*0.85 ,
                height: verticalPadding*0.065,
              ),
              SizedBox(height: verticalPadding*0.01,),
              commonTextfield(
                controller: controller.passController,
                hinttext: "Password",
                obstxt: true,
                width: horizontalPadding*0.85 ,
                height: verticalPadding*0.065,
              ),
              SizedBox(height:verticalPadding*0.03),
              commonButton(
                onNavigate: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
                },
                buttonName: "login",
                width: horizontalPadding*0.85,
                height: verticalPadding*0.07,
                clr: Colors.black,
                txtclr: Colors.white,
              ),
              SizedBox(height:verticalPadding*0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding*0.12),
                child: Divider(height: 1,),
              ),
              Text("OR", style: TextStyle(fontSize: 18,),),
              SizedBox(height:verticalPadding*0.04),
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
    );
  }
}
