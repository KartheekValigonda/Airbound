import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../controller/auth_controller.dart';

class AdditionalInfoController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final _authController = Get.find<AuthController>();

  // Form controllers
  final cigarettesController = TextEditingController();
  final costController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to text changes for form validation
    cigarettesController.addListener(_validateForm);
    costController.addListener(_validateForm);
  }

  void _validateForm() {
    final cigarettes = int.tryParse(cigarettesController.text);
    final cost = double.tryParse(costController.text);
    isFormValid.value = cigarettes != null && cigarettes > 0 && cost != null && cost > 0;
  }

  Future<void> saveAndNavigate() async {
    if (!isFormValid.value) return;

    isLoading.value = true;

    try {
      final user = _authController.user.value;
      if (user != null) {
        await _firestoreService.updateUserAdditionalInfo(
          userId: user.uid,
          cigarettesPerDay: int.parse(cigarettesController.text),
          costPerCigarette: double.parse(costController.text),
        );

        Get.snackbar(
          'Success',
          'Information saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/home');
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
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    cigarettesController.dispose();
    costController.dispose();
    super.onClose();
  }
} 