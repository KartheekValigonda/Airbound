import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
