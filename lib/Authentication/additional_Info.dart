import 'dart:math' as math;
import 'package:airbound/Home/home.dart';
import 'package:airbound/Theme/color_pallet.dart';
import 'package:airbound/common%20widgets/commontextfield.dart';
import 'package:airbound/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdditionalInfo extends StatefulWidget {
  const AdditionalInfo({super.key});

  @override
  State<AdditionalInfo> createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  final _formKey = GlobalKey<FormState>();
  final _cigarettesController = TextEditingController();
  final _costController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _isLoading = false.obs;

  Future<void> _saveAndNavigate() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      _isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestoreService.updateUserAdditionalInfo(
        userId: userId,
        cigarettesPerDay: int.parse(_cigarettesController.text),
        costPerCigarette: double.parse(_costController.text),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } catch (e) {
      print('Error saving additional info: $e');
      Get.snackbar(
        'Error',
        'Failed to save information. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _cigarettesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Pallete.gradient1, Pallete.gradient2]),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.05,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Let's get to know you better",
                        style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "This information will help us track your progress better",
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            commonTextfield(
                              controller: _cigarettesController,
                              hinttext: "Cigarettes Per Day",
                              keyboardType: TextInputType.number,
                              width: screenWidth * 0.8,
                              height: 60,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter number of cigarettes';
                                }
                                final number = int.tryParse(value);
                                if (number == null || number <= 0) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              context: context,
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            commonTextfield(
                              controller: _costController,
                              hinttext: "Cost Per Cigarette (₹)",
                              keyboardType: TextInputType.number,
                              width: screenWidth * 0.8,
                              height: 60,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter cost per cigarette';
                                }
                                final number = double.tryParse(value);
                                if (number == null || number <= 0) {
                                  return 'Please enter a valid amount';
                                }
                                return null;
                              },
                              context: context,
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            SizedBox(
                              width: double.infinity,
                              height: screenHeight * 0.06,
                              child: ElevatedButton(
                                onPressed: _isLoading.value ? null : _saveAndNavigate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Pallete.bigCard,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Obx(() => _isLoading.value
                                  ? const CircularProgressIndicator()
                                  : Text(
                                    "Let's dive in!",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}