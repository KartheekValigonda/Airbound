import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/info.dart';
import 'package:airbound/loginpage.dart';
import 'package:airbound/signup1.dart';
import 'package:flutter/material.dart';

class openingpg extends StatefulWidget {
  const openingpg({super.key});

  @override
  State<openingpg> createState() => _openingpgState();
}

class _openingpgState extends State<openingpg> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width ;
    final verticalPadding = MediaQuery.of(context).size.height;
    return  Scaffold(
      appBar:AppBar(
        title:const Text(""),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding*0.1, vertical: verticalPadding*0.1 ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: verticalPadding*0.07),
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:horizontalPadding*0.03,
                    vertical: verticalPadding*0.02),
                child: const Text("Welcome to a  healthier life.", textAlign: TextAlign.center,style: TextStyle(fontSize: 36, fontWeight:FontWeight.w500),),
              ),
              const Text("Start your journey towards freedom from smoking and regain more time and health",textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
              SizedBox(height: verticalPadding*0.06,),
              commonButton(
                onNavigate: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Info()));},
                buttonName: "Let's get started!",
                width: horizontalPadding*0.8,
                height: verticalPadding*0.06,
                clr: Colors.black
              ),
              SizedBox(height: verticalPadding*0.02,),
              commonButton(
                onNavigate: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const loginpage()));},
                buttonName: "I already have an account",
                width: horizontalPadding*0.8,
                height: verticalPadding*0.06,
                txtclr: Colors.black
              ),
            ],
          ),
        ),
      ),
    );
  }
}
