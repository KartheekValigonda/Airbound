import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user document in Firestore
  Future<void> createUserDocument({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
        'cigarettesPerDay': 0,
        'costPerCigarette': 0.0,
        'totalCigarettesSmoked': {},
        'profilePhotosUrl': null,
      });
    } catch (e) {
      print('Error creating user document: $e');
      rethrow;
    }
  }

  // Get today's cigarette count
  Future<int> getTodayCigaretteCount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final today = DateTime.now();
        final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        print('Getting cigarette count for date: $dateKey');
        
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          final totalCigarettesSmoked = data?['totalCigarettesSmoked'] as Map<String, dynamic>?;
          return totalCigarettesSmoked?[dateKey]?['count'] ?? 0;
        }
        return 0;
      }
      print('No authenticated user found');
      return 0;
    } catch (e) {
      print('Error getting today\'s cigarette count: $e');
      return 0;
    }
  }

  // Update today's cigarette count
  Future<void> updateTodayCigaretteCount(int count) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final today = DateTime.now();
        final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        print('Updating cigarette count to $count for date: $dateKey');
        
        await _firestore.collection('users').doc(user.uid).update({
          'totalCigarettesSmoked.$dateKey': {
            'count': count,
            'date': Timestamp.fromDate(today),
            'lastUpdated': FieldValue.serverTimestamp(),
          },
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('Cigarette count updated successfully');
      } else {
        print('No authenticated user found');
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      print('Error updating today\'s cigarette count: $e');
      rethrow;
    }
  }

  // Reset daily cigarette count at midnight
  Future<void> resetDailyCigaretteCount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final today = DateTime.now();
        final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        print('Resetting cigarette count for date: $dateKey');
        
        final docRef = _firestore
            .collection('user')
            .doc(user.uid)
            .collection('total_cigarette_smoked')
            .doc(dateKey);
        
        await docRef.set({
          'count': 0,
          'date': Timestamp.fromDate(today),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('Daily cigarette count reset successfully');
      } else {
        print('No authenticated user found');
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      print('Error resetting daily cigarette count: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('Getting user data for user ID: ${user.uid}');
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          print('User data retrieved successfully');
          return doc.data();
        } else {
          print('No user document found');
          return null;
        }
      } else {
        print('No authenticated user found');
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData({
    required String name,
    required String email,
    String? profileUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('Updating user data for user ID: ${user.uid}');
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': name,
          'email': email,
          if (profileUrl != null) 'profileUrl': profileUrl,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        print('User data updated successfully');
      } else {
        print('No authenticated user found');
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  // Get cigarette data for the last 7 days
  Future<List<Map<String, dynamic>>> getLastWeekCigaretteData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return [];
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return [];

      final data = doc.data();
      final totalCigarettesSmoked = data?['totalCigarettesSmoked'] as Map<String, dynamic>?;
      if (totalCigarettesSmoked == null) return [];

      final now = DateTime.now();
      final List<Map<String, dynamic>> result = [];

      for (int i = 6; i >= 0; i--) {
        final date = DateTime(now.year, now.month, now.day - i);
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        
        final dayData = totalCigarettesSmoked[dateKey];
        result.add({
          'date': date,
          'count': dayData?['count'] ?? 0,
        });
      }

      return result;
    } catch (e) {
      print('Error getting last week cigarette data: $e');
      return [];
    }
  }

  // Get cigarette data for a specific date range
  Future<List<Map<String, dynamic>>> getCigaretteDataForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return [];
      }

      final List<Map<String, dynamic>> data = [];
      DateTime currentDate = startDate;

      while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
        final dateKey = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
        
        final doc = await _firestore
            .collection('user')
            .doc(user.uid)
            .collection('total_cigarette_smoked')
            .doc(dateKey)
            .get();

        if (doc.exists) {
          data.add({
            'date': currentDate,
            'count': doc.data()?['count'] ?? 0,
          });
        } else {
          data.add({
            'date': currentDate,
            'count': 0,
          });
        }

        currentDate = currentDate.add(const Duration(days: 1));
      }

      print('Retrieved date range data: $data');
      return data;
    } catch (e) {
      print('Error getting cigarette data for date range: $e');
      return [];
    }
  }

  // Update user additional information
  Future<void> updateUserAdditionalInfo({
    required String userId,
    required int cigarettesPerDay,
    required double costPerCigarette,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'cigarettesPerDay': cigarettesPerDay.toDouble(),
        'costPerCigarette': costPerCigarette,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Successfully updated user additional info for user: $userId');
    } catch (e) {
      print('Error updating user additional info: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserAdditionalInfo(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return {
          'cigarettesPerDay': doc.data()?['cigarettesPerDay'] ?? 0.0,
          'costPerCigarette': doc.data()?['costPerCigarette'] ?? 0.0,
        };
      }
      return {'cigarettesPerDay': 0.0, 'costPerCigarette': 0.0};
    } catch (e) {
      print('Error fetching user additional info: $e');
      rethrow;
    }
  }
}