import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.grey[300], // Light grey background
      body: Column(
        children: [
          SizedBox(height: screenHeight*0.12),
          // Profile Information
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150", // Replace with actual image
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "James Smith",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "smith@gmail.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight*0.03),
          // Settings Options
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.055),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildSettingsOption(
                        Icons.account_balance, "Account setup", context),
                    _buildSettingsOption(Icons.person, "Profile setting", context),
                    _buildSettingsOption(Icons.policy, "Privacy policy", context),
                    _buildSettingsOption(
                        Icons.help_outline, "Help and support", context),
                    const Divider(),
                    _buildLogoutOption(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Settings Options
  Widget _buildSettingsOption(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }

  // Widget for Logout Option
  Widget _buildLogoutOption(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Log out",
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {},
    );
  }
}
