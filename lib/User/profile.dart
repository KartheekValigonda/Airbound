import 'package:airbound/Authentication/loginpage.dart';
import 'package:airbound/User/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Theme/color_pallet.dart';
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
  String? _profilePicUrl;
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
          _isLoading = false;
        });
        return;
      }

      final userData = await _firestoreService.getUserData();
      if (userData != null) {
        setState(() {
          _userName = userData['name'] ?? "User";
          _profilePicUrl = userData['profile_pic'];
          _isLoading = false;
        });
      } else {
        print("No user data found in Firestore");
        setState(() {
          _userName = user.displayName ?? "User";
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _userName = "Error loading data";
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

  Future<void> _handleDeleteAccount() async {
    try {
      // Show confirmation dialog
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirm != true) {
        return;
      }

      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.back(); // Close loading dialog
        Get.snackbar(
          'Error',
          'No user found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Delete user data from Firestore
      await _firestoreService.deleteUserData();

      // Delete user account
      await user.delete();

      // Close loading dialog
      Get.back();

      // Show success message
      Get.snackbar(
        'Success',
        'Account deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login page and clear navigation stack
      Get.offAll(() => LoginPage());
    } catch (e) {
      print('Error deleting account: $e');
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to delete account: ${e.toString()}',
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
      backgroundColor: Pallete.backgroundColor,
      body: Stack(
        children: [
          ClipPath(
            child: Container(
              height: screenHeight*0.35,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Pallete.gradient1,Pallete.gradient2]),
                  borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: screenHeight * 0.12),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _profilePicUrl != null
                          ? NetworkImage(_profilePicUrl!)
                          : null,
                      child: _profilePicUrl == null
                          ? const Icon(Icons.person, size: 70, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      Column(
                        children: [
                          Text(
                            _userName,
                            style: theme.textTheme.bodyLarge
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
                    color: Pallete.bigCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        _buildSettingsOption(
                          Icons.account_balance,
                          "Account setup",
                              (){Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProfile()));},
                          context,
                        ),
                        
                        Divider(color: theme.dividerColor),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Pallete.authButton),
                          title: Text(
                            "Log out",
                              style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          onTap: _handleLogout,
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_forever, color: Colors.red),
                          title: Text(
                            "Delete Account",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.red,
                              ),
                          ),
                          onTap: _handleDeleteAccount,
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
  Widget _buildSettingsOption(IconData icon, String title, ontap, BuildContext context,) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: Pallete.authButton),
      title: Text(title, style: theme.textTheme.bodyMedium),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Pallete.authButton,
      ),
      onTap: ontap,
    );
  }
}