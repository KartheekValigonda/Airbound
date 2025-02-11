import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track and Crack",
          style: TextStyle(color: Colors.white,),
        ),
        backgroundColor: Colors.black, // Set background color to black
        iconTheme: IconThemeData(color: Colors.white), // Change back button and icons to white
        centerTitle: true, // Center the title text
        elevation: 0, // Remove shadow
      ),
    );
  }
}
