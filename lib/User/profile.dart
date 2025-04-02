import 'package:airbound/Authentication/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();
  String _userName = "Loading...";
  String _userEmail = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No authenticated user found");
        setState(() {
          _userName = "Not logged in";
          _userEmail = "";
          _isLoading = false;
        });
        return;
      }

      final userData = await _firestoreService.getUserData();
      if (userData != null) {
        setState(() {
          _userName = userData['name'] ?? "User";
          _userEmail = userData['email'] ?? user.email ?? "";
          _isLoading = false;
        });
      } else {
        print("No user data found in Firestore");
        setState(() {
          _userName = user.displayName ?? "User";
          _userEmail = user.email ?? "";
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _userName = "Error loading data";
        _userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to load user data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      // Show confirmation dialog
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('Logout'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirm != true) {
        return;
      }

      await _authController.signOut();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF006A67),
      body: Column(
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
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      Text(
                        _userName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _userEmail,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          // Settings Options
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.055),
              child: Card(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildSettingsOption(
                      Icons.account_balance,
                      "Account setup",
                      context,
                    ),
                    _buildSettingsOption(
                      Icons.person,
                      "Profile setting",
                      context,
                    ),
                    _buildSettingsOption(
                      Icons.policy,
                      "Privacy policy",
                      context,
                    ),
                    _buildSettingsOption(
                      Icons.help_outline,
                      "Help and support",
                      context,
                    ),
                    Divider(color: theme.dividerColor),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.black),
                      title: const Text(
                        "Log out",
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: _handleLogout,
                    ),
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
  Widget _buildSettingsOption(
    IconData icon,
    String title,
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.iconTheme.color?.withOpacity(0.7),
      ),
      onTap: () {},
    );
  }
}