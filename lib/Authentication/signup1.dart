import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/Authentication/signup2.dart';
import 'package:flutter/material.dart';


class Signup1 extends StatefulWidget {
  const Signup1({super.key});

  @override
  State<Signup1> createState() => _Signup1State();
}

class _Signup1State extends State<Signup1> {
  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width ;
    final verticalPadding = MediaQuery.of(context).size.height ;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome to Airbound",
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
                    text: TextSpan(
                      text: 'You can become a ',
                      style: Theme.of(context).textTheme.titleLarge,
                      children: [
                        TextSpan(
                            text: 'happy',
                            style: TextStyle(fontStyle: FontStyle.italic)),
                        TextSpan(
                          text: ' non-smoker ',
                        ),
                        TextSpan(
                          text: ' How?',
                        )
                      ],
                    ),
                  ),
                  Text(
                    "First let's explore your unique challenges and understand your smoking journey. This will help us create a plan that truly fits your needs.",
                    style: Theme.of(context).textTheme.bodyMedium,
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
