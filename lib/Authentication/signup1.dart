import 'dart:ui';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/Authentication/signup2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Signup1 extends StatefulWidget {
  const Signup1({super.key});

  @override
  State<Signup1> createState() => _signup1State();
}

class _signup1State extends State<Signup1> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width ;
    final verticalPadding = MediaQuery.of(context).size.height ;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006A67),
        title: const Text(
          "Welcome to Airbound",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding*0.05,
          vertical: verticalPadding*0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: verticalPadding*0.02,),
                  RichText(
                    text: const TextSpan(
                      text: 'You can become a ',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                      children: [
                        TextSpan(
                            text: 'happy',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        TextSpan(
                          text: ' non-smoker ',
                        ),
                        TextSpan(
                          text: ' How?',
                          style: TextStyle(fontWeight: FontWeight.w500)
                        )
                      ],
                    ),
                  ),
                  const Text(
                    "First let's explore your unique challenges and understand your smoking journey. This will help us create a plan that truly fits your needs.",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: verticalPadding*0.04),
              Column(
                children: [
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/doc.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: verticalPadding*0.14),
              Column(
                children: [
                  commonButton(
                    onNavigate: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>  Signup2()));
                    },
                    buttonName:"Continue",
                    width:horizontalPadding*0.75,
                    height:verticalPadding*0.065,
                    clr:Colors.black,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
