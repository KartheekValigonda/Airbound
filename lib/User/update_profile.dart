import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Theme/color_pallet.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cigarettesPerDayController = TextEditingController();
  final _costPerCigaretteController = TextEditingController();
  final _isLoading = false.obs;
  final _selectedProfilePic = RxnString();
  final _profilePics = <String>[].obs;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProfilePics();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (userData.exists) {
        _nameController.text = userData.data()?['name'] ?? '';
        _selectedProfilePic.value = userData.data()?['profile_pic'];
        
        // Load cigarettes per day
        final cigarettesPerDay = userData.data()?['cigarettesPerDay'];
        if (cigarettesPerDay != null) {
          _cigarettesPerDayController.text = cigarettesPerDay.toString();
        }
        
        // Load cost per cigarette
        final costPerCigarette = userData.data()?['costPerCigarette'];
        if (costPerCigarette != null) {
          _costPerCigaretteController.text = costPerCigarette.toString();
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load user data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadProfilePics() async {
    try {
      print('Loading profile pictures...');
      final snapshot = await FirebaseFirestore.instance
          .collection('profile_avatar')
          .get();
      
      print('Found ${snapshot.docs.length} profile pictures');
      
      final List<String> urls = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final url = data['url'];
        
        if (url == null) {
          print('Warning: Document ${doc.id} has no url field');
          continue;
        }
        
        if (url is! String) {
          print('Warning: Document ${doc.id} has invalid url type: ${url.runtimeType}');
          continue;
        }
        
        print('Profile picture URL: $url');
        urls.add(url);
      }
      
      if (urls.isEmpty) {
        print('No valid profile picture URLs found');
        Get.snackbar(
          "Warning",
          "No valid profile pictures found in database",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      
      _profilePics.value = urls;
      print('Successfully loaded ${urls.length} profile pictures');
    } catch (e) {
      print('Error loading profile pictures: $e');
      Get.snackbar(
        "Error",
        "Failed to load profile pictures: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showProfilePicSelector() {
    if (_profilePics.isEmpty) {
      Get.snackbar(
        "Info",
        "No profile pictures available",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    print('Showing profile pic selector with ${_profilePics.length} images');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Profile Picture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        await _loadProfilePics();
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showProfilePicSelector();
                        }
                      },
                      tooltip: 'Refresh profile pictures',
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                print('Building grid with ${_profilePics.length} images');
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _profilePics.length,
                  itemBuilder: (context, index) {
                    final imageUrl = _profilePics[index];
                    print('Building grid item $index with URL: $imageUrl');
                    return GestureDetector(
                      onTap: () {
                        _selectedProfilePic.value = imageUrl;
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedProfilePic.value == imageUrl
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading image: $error');
                              return const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (uid == null) return;
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      Map<String, dynamic> updateData = {};

      // Update name in Firestore
      if (_nameController.text.trim().isNotEmpty) {
        updateData['name'] = _nameController.text.trim();
      }

      // Update profile picture in Firestore
      if (_selectedProfilePic.value != null) {
        updateData['profile_pic'] = _selectedProfilePic.value;
      }
      
      // Update cigarettes per day
      if (_cigarettesPerDayController.text.trim().isNotEmpty) {
        final cigarettesPerDay = int.tryParse(_cigarettesPerDayController.text.trim());
        if (cigarettesPerDay != null) {
          updateData['cigarettesPerDay'] = cigarettesPerDay;
        }
      }
      
      // Update cost per cigarette
      if (_costPerCigaretteController.text.trim().isNotEmpty) {
        final costPerCigarette = double.tryParse(_costPerCigaretteController.text.trim());
        if (costPerCigarette != null) {
          updateData['costPerCigarette'] = costPerCigarette;
        }
      }

      // Update Firestore document
      if (updateData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update(updateData);

        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        Get.back();
      }
    } catch (e) {
      print('Error in updateProfile: $e');
      Get.snackbar(
        "Error",
        "An unexpected error occurred: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cigarettesPerDayController.dispose();
    _costPerCigaretteController.dispose();
    super.dispose();
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
          // Gradient background header
          ClipPath(
            child: Container(
              height: screenHeight * 0.28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Pallete.gradient1, Pallete.gradient2],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.12),
                // Profile picture
                GestureDetector(
                  onTap: _showProfilePicSelector,
                  child: Stack(
                    children: [
                      Obx(() => CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _selectedProfilePic.value != null
                            ? NetworkImage(_selectedProfilePic.value!)
                            : null,
                        child: _selectedProfilePic.value == null
                            ? const Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                      )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Form fields
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _nameController,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: theme.textTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Pallete.authButton),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            prefixIcon: const Icon(Icons.person, color: Pallete.authButton),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Cigarettes per day field
                      Container(
                        width: screenWidth * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _cigarettesPerDayController,
                          style: theme.textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cigarettes per Day',
                            labelStyle: theme.textTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Pallete.authButton),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            prefixIcon: const Icon(Icons.smoking_rooms, color: Pallete.authButton),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final number = int.tryParse(value);
                              if (number == null) {
                                return 'Please enter a valid number';
                              }
                              if (number < 0) {
                                return 'Number cannot be negative';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Cost per cigarette field
                      Container(
                        width: screenWidth * 0.9,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _costPerCigaretteController,
                          style: theme.textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cost per Cigarette (₹)',
                            labelStyle: theme.textTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Pallete.authButton),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            prefixIcon: const Icon(Icons.currency_rupee, color: Pallete.authButton),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final number = double.tryParse(value);
                              if (number == null) {
                                return 'Please enter a valid number';
                              }
                              if (number < 0) {
                                return 'Cost cannot be negative';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      // Update button
                      Container(
                        width: screenWidth * 0.8,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                          onPressed: _isLoading.value ? null : _updateProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.authButton,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: _isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Update Profile',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//check