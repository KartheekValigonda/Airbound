import 'package:flutter/material.dart';

class Dailytask extends StatefulWidget {
  const Dailytask({super.key});

  @override
  State<Dailytask> createState() => _DailytaskState();
}

class _DailytaskState extends State<Dailytask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Airbound",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black, // Set background color to black
        iconTheme: const IconThemeData(color: Colors.white), // Change back button and icons to white
        centerTitle: true, // Center the title text
        elevation: 0, // Remove shadow
      ),
    );
  }
}
