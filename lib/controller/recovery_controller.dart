import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firestore_service.dart';
import '../controller/auth_controller.dart';

class RecoveryController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final _authController = Get.find<AuthController>();

  // Observable variables
  final RxDouble monthlyExpenditure = 0.0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMonthlyExpenditure();
  }

  Future<void> _loadMonthlyExpenditure() async {
    try {
      final user = _authController.user.value;
      if (user != null) {
        final userData = await _firestoreService.getUserAdditionalInfo(user.uid);
        final cigarettesPerDay = (userData['cigarettesPerDay'] as num?)?.toDouble() ?? 0.0;
        final costPerCigarette = (userData['costPerCigarette'] as num?)?.toDouble() ?? 0.0;
        
        monthlyExpenditure.value = cigarettesPerDay * costPerCigarette * 30;
        isLoading.value = false;
      }
    } catch (e) {
      print('Error loading monthly expenditure: $e');
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load expenditure data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 