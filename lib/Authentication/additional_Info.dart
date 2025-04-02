import 'dart:math' as math;
import 'package:airbound/Home/home.dart';
import 'package:airbound/common%20widgets/commontextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../services/firestore_service.dart';

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
  final AuthController _authController = Get.find<AuthController>(); // Access controller via Get.find

  @override
  void dispose() {
    _cigarettesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _saveAndNavigate() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      final user = _authController.user.value;
      if (user != null) {
        await _firestoreService.updateUserAdditionalInfo(
          userId: user.uid,
          cigarettesPerDay: int.parse(_cigarettesController.text),
          costPerCigarette: double.parse(_costController.text),
        );

        Get.snackbar(
          'Success',
          'Information saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => const Home());
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.25,
              right: screenWidth * 0.1,
              child: Transform.rotate(
                angle: 45 * math.pi / 180,
                child: Container(
                  width: screenWidth * 2,
                  height: screenWidth * 2.1,
                  color: const Color(0xFF006A67),
                ),
              ),
            ),
            SingleChildScrollView(
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
                      SizedBox(height: screenHeight * 0.2),
                      Text(
                        "Let's get to know you better",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "This information will help us track your progress better",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: screenHeight * 0.05),
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
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading.value ? null : _saveAndNavigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF006A67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: _isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text(
                            "Let's dive in!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
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