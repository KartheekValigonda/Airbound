import 'package:airbound/Authentication/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logoutMethod() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const loginpage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context); // Access theme data

    return Scaffold(
      body: Stack(
        children: [
          // Green background container (rotated)
          Positioned(
            top: -screenHeight * 0.1,
            right: -screenWidth * 0.2,
            child: Transform.rotate(
              angle: 52 * math.pi / 180,
              child: Container(
                width: screenHeight * 2,
                height: screenWidth * 2.1,
                color: theme.colorScheme.primary, // Use primary color from theme
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: screenHeight * 0.12),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "James Smith",
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "smith@gmail.com",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Settings Options
              Expanded(
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
                  child: Card(
                    color: theme.cardColor, // Use card color from theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsOption(
                            Icons.account_balance, "Account setup", context),
                        _buildSettingsOption(
                            Icons.person, "Profile setting", context),
                        _buildSettingsOption(
                            Icons.policy, "Privacy policy", context),
                        _buildSettingsOption(
                            Icons.help_outline, "Help and support", context),
                        Divider(color: theme.dividerColor),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.black),
                          title: const Text(
                            "Log out",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            logoutMethod();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for Settings Options
  Widget _buildSettingsOption(
      IconData icon, String title, BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(Icons.arrow_forward_ios,
          size: 16, color: theme.iconTheme.color?.withOpacity(0.7)),
      onTap: () {},
    );
  }
}