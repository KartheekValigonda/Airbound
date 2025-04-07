import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Theme/color_pallet.dart';
import '../controller/auth_controller.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  final _firestoreService = FirestoreService();
  final _monthlyExpenditure = 0.0.obs;
  final _isLoading = true.obs;
  final _progressValue = 0.0.obs;
  final _lastSmokeTime = DateTime.now().obs;
  Timer? _progressTimer;
  final _progressValue12Hours = 0.0.obs;
  final _progressValue60Days = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _loadMonthlyExpenditure();
    _loadLastSmokeTime();
    _startProgressTimer();
  }

  Future<void> _loadLastSmokeTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSmokeTimeStr = prefs.getString('lastSmokeTime');
      if (lastSmokeTimeStr != null) {
        _lastSmokeTime.value = DateTime.parse(lastSmokeTimeStr);
      }
    } catch (e) {
      print('Error loading last smoke time: $e');
    }
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      Duration diff = DateTime.now().difference(_lastSmokeTime.value);
      _updateProgress(diff);
      _updateProgress12Hours(diff);
      _updateProgress60Days(diff);
    });
  }

  void _updateProgress(Duration diff) {
    const twentyMinutes = Duration(minutes: 20);
    if (diff.inSeconds <= twentyMinutes.inSeconds) {
      _progressValue.value = diff.inSeconds / twentyMinutes.inSeconds;
    } else {
      _progressValue.value = 1.0;
    }
  }

  void _updateProgress12Hours(Duration diff) {
    const twelveHours = Duration(hours: 12);
    if (diff.inSeconds <= twelveHours.inSeconds) {
      _progressValue12Hours.value = diff.inSeconds / twelveHours.inSeconds;
    } else {
      _progressValue12Hours.value = 1.0;
    }
  }

  void _updateProgress60Days(Duration diff) {
    const sixtyDays = Duration(days: 60);
    if (diff.inSeconds <= sixtyDays.inSeconds) {
      _progressValue60Days.value = diff.inSeconds / sixtyDays.inSeconds;
    } else {
      _progressValue60Days.value = 1.0;
    }
  }

  Widget _buildProgressBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Obx(() => Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: screenHeight*0.24,
                width: screenWidth*0.5,
                child: CircularProgressIndicator(
                  value: _progressValue.value,
                  strokeWidth: 30,
                  backgroundColor: Pallete.bigCard,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progressValue.value >= 1.0
                      ? Pallete.authButton
                      : Pallete.authButton,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _progressValue.value >= 1.0 
                      ? "completed! 🎉"
                      : "${(20 - (DateTime.now().difference(_lastSmokeTime.value).inMinutes)).toString()} mins remaining",
                    style: TextStyle(
                      color: _progressValue.value >= 1.0 ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "20 minutes After Quitting",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your heart rate and blood pressure drop.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: screenHeight*0.24,
                width: screenWidth*0.5,
                child: CircularProgressIndicator(
                  value: _progressValue12Hours.value,
                  strokeWidth: 30,
                  backgroundColor: Pallete.bigCard,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progressValue12Hours.value >= 1.0 
                      ? Pallete.authButton
                      : Pallete.authButton,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _progressValue12Hours.value >= 1.0 
                      ? "completed! 🎉"
                      : "${(12 - (DateTime.now().difference(_lastSmokeTime.value).inHours)).toString()} hours remaining",
                    style: TextStyle(
                      color: _progressValue12Hours.value >= 1.0 ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "12 hours After Quitting",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Carbon monoxide level in your blood drops to normal.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: screenHeight*0.24,
                width: screenWidth*0.5,
                child: CircularProgressIndicator(
                  value: _progressValue60Days.value,
                  strokeWidth: 30,
                  backgroundColor: Pallete.bigCard,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _progressValue60Days.value >= 1.0 
                      ? Pallete.authButton
                      : Pallete.authButton,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _progressValue60Days.value >= 1.0 
                      ? "60 days completed! 🎉" 
                      : "${(60 - (DateTime.now().difference(_lastSmokeTime.value).inDays)).toString()} days remaining",
                    style: TextStyle(
                      color: _progressValue60Days.value >= 1.0 ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "60 days After Quitting",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your lung function improves significantly.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  }

  Future<void> _loadMonthlyExpenditure() async {
    try {
      final user = Get.find<AuthController>().user.value;
      if (user != null) {
        final userData = await _firestoreService.getUserAdditionalInfo(user.uid);
        final cigarettesPerDay = (userData['cigarettesPerDay'] as num?)?.toInt() ?? 0;
        final costPerCigarette = (userData['costPerCigarette'] as num?)?.toDouble() ?? 0.0;
        final lastSmokeTime = userData['lastSmokeTime'] as Timestamp?;
        
        if (lastSmokeTime != null) {
          _lastSmokeTime.value = lastSmokeTime.toDate();
        }

        _monthlyExpenditure.value = (cigarettesPerDay * costPerCigarette * 30);
      }
    } catch (e) {
      print('Error loading monthly expenditure: $e');
      Get.snackbar(
        'Error',
        'Failed to load monthly expenditure',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Pallete.gradient1,Pallete.gradient2],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,),
        ),
        child: Obx(() => _isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.03,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.06),
                      Text("Recovery", style: theme.textTheme.titleLarge),
                      SizedBox(height: screenHeight * 0.05),
                      Container(
                        width: screenWidth * 0.87,
                        height: screenHeight * 0.065,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Pallete.bigCard,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Monthly Expenditure",
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            Text(
                              "₹${_monthlyExpenditure.value.toStringAsFixed(2)}",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      _buildProgressBar(),
                      SizedBox(height: screenHeight * 0.03),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:[
                            Container(
                            decoration: BoxDecoration(
                              color: Pallete.bigCard,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Pallete.authButton,
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            width: screenWidth*0.5,
                              height: screenHeight*0.4,
                              padding: EdgeInsets.all(16),
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            child: Column(
                              children: [
                                Text("1 year after quitting",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),),
                                SizedBox(height: screenHeight * 0.02),
                                Text("Your risk of heart disease is cut in half.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                  ),),
                              ],
                            ),
                          ),
                            Container(
                              decoration: BoxDecoration(
                                color: Pallete.bigCard,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Pallete.authButton,
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: screenWidth*0.5,
                              height: screenHeight*0.4,
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              child: Column(
                                children: [
                                  Text("2 to 5 years after quitting",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black,
                                    ),),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text("Your risk of cancers of the mouth, throat, esophagus, and bladder is cut in half. Your stroke risk drops to that of a person who doesn't smoke.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),),
                                ],
                              ),
                            ),
                         ]
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}
