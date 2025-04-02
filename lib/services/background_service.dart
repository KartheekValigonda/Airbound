import 'dart:async';
import 'package:flutter/material.dart';
import 'firestore_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final FirestoreService _firestoreService = FirestoreService();
  Timer? _timer;

  void startService() {
    // Check if it's midnight every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        try {
          await _firestoreService.resetDailyCigaretteCount();
          debugPrint('Daily cigarette count reset at midnight');
        } catch (e) {
          debugPrint('Error resetting daily cigarette count: $e');
        }
      }
    });
  }

  void stopService() {
    _timer?.cancel();
  }
} 