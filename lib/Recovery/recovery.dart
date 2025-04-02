import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../services/firestore_service.dart';

class Recovery extends GetView<AuthController> {
  final _firestoreService = FirestoreService();
  final _monthlyExpenditure = 0.0.obs;
  final _isLoading = true.obs;

  Recovery({super.key}) {
    _loadMonthlyExpenditure();
  }

  Future<void> _loadMonthlyExpenditure() async {
    try {
      final user = controller.user.value;
      if (user != null) {
        final userData = await _firestoreService.getUserAdditionalInfo(user.uid);
        final cigarettesPerDay = (userData['cigarettesPerDay'] as num?)?.toDouble() ?? 0.0;
        final costPerCigarette = (userData['costPerCigarette'] as num?)?.toDouble() ?? 0.0;
        
        _monthlyExpenditure.value = cigarettesPerDay * costPerCigarette * 30;
        _isLoading.value = false;
      }
    } catch (e) {
      print('Error loading monthly expenditure: $e');
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load expenditure data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recovery"),
      ),
      body: Obx(() => _isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Your monthly expenditure on cigarettes:",
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        "₹${_monthlyExpenditure.value.toStringAsFixed(2)}",
                        style: theme.textTheme.bodySmall),
                    ],
                  ),

                ],
              ),
            )),
    );
  }
}
