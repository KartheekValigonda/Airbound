import 'package:airbound/Home/home.dart';
import 'package:airbound/common%20widgets/commonbutton.dart';
import 'package:airbound/common%20widgets/commontextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  final FocusNode _textFieldFocusNode = FocusNode();
  var controller = Get.put(AuthController());

  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_handleFocusChange);
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_textFieldFocusNode.hasFocus) {
      showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Provide a unique username",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "This will be used to identify your profile.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Got it"),
              ),
            ],
          ),
        ),
      );
    }
  }

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
              const Text("Sign Up",style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),),
              SizedBox(height: verticalPadding*0.03,),
              commonTextfield(
                controller: controller.emailController,
                hinttext: "Name",
                obstxt: false,
                width: horizontalPadding*0.85 ,
                height: verticalPadding*0.065,
              ),
              SizedBox(height: verticalPadding*0.01,),
              commonTextfield(
                controller: controller.passController,
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
              SizedBox(height: verticalPadding*0.01,),
              commonTextfield(
                controller: controller.passController,
                hinttext: "Date Of Birth",
                obstxt: false,
                width: horizontalPadding*0.85 ,
                height: verticalPadding*0.065,
              ),
              SizedBox(height:verticalPadding*0.03),
              commonButton(
                onNavigate: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                },
                buttonName: "Sign Up",
                width: horizontalPadding*0.85,
                height: verticalPadding*0.07,
                clr: Colors.black,
                txtclr: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
