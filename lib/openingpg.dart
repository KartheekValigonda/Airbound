import 'package:airbound/Theme/color_pallet.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/Authentication/info.dart';
import 'package:airbound/Authentication/loginpage.dart';
import 'package:flutter/material.dart';

class OpeningPg extends StatefulWidget {
  const OpeningPg({super.key});

  @override
  State<OpeningPg> createState() => _OpeningPgState();
}

class _OpeningPgState extends State<OpeningPg> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width ;
    final verticalPadding = MediaQuery.of(context).size.height;
    return  Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: verticalPadding*0.3,
            bottom: verticalPadding*0.2,
            left:horizontalPadding*0.07,
            right:horizontalPadding*0.07),
        child: Stack(
          children:[
            Positioned(
              top: 10,
              right: 50,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(32), // Optional: Rounded corners
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Pallete.gradient1, Pallete.gradient2],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:horizontalPadding*0.03,
                    vertical: verticalPadding*0.04
                ),
                child: Column(
                children: [
                  const Text("Welcome to a  healthier life.", textAlign: TextAlign.center,style: TextStyle(fontSize: 32, fontWeight:FontWeight.w500),),
                  Text("Start your journey towards freedom from smoking and regain more time and health",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(height: verticalPadding*0.06,),
                  commonButton(
                    onNavigate: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Info()));},
                    buttonName: "Let's get started!",
                    width: horizontalPadding*0.8,
                    height: verticalPadding*0.06,
                      clr: Pallete.bigCard
                  ),
                  SizedBox(height: verticalPadding*0.02,),
                  commonButton(
                    onNavigate: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));},
                    buttonName: "I already have an account",
                    width: horizontalPadding*0.8,
                    height: verticalPadding*0.06,
                    txtclr: Colors.black
                  ),
                ],
                            ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
