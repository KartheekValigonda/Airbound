import 'package:airbound/Authentication/additional_info.dart';
import 'package:airbound/Authentication/loginpage.dart';
import 'package:airbound/Authentication/verificationScreen.dart';
import 'package:airbound/Home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AuthController extends GetxController {
  final _firestoreService = FirestoreService();
  final user = Rxn<firebase_auth.User>();
  final isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(firebase_auth.FirebaseAuth.instance.authStateChanges());
  }

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
          
      if (userCredential.user != null) {
        // Check if user has completed additional info
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
            
        if (userDoc.exists && userDoc.data()?['additionalInfoCompleted'] == true) {
          Get.offAll(() => const Home());
        } else {
          Get.offAll(() => const AdditionalInfo());
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Something went wrong",
          backgroundColor: Colors.black45, colorText: Colors.white);
    }

    return userCredential;
  }

  //storing data
  Future<void> storeUserData({name, email}) async {
    DocumentReference store = FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await store.set({
      'name': name,
      'email': email,
      'additionalInfoCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // email verification
  Future<void> sendEmailVerification({context}) async{
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      Get.snackbar(
        'Success',
        'Verification email sent. Please check your inbox.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Failed to send verification email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;

      // Create user in Firebase Auth
      final userCredential = await firebase_auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final String uid = userCredential.user!.uid;
        
        // Update display name in Firebase Auth
        await userCredential.user!.updateDisplayName(name);

        // Create user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
          'cigarettesPerDay': 0,
          'costPerCigarette': 0.0,
          'totalCigarettesSmoked': {},
          'profilePhotosUrl': null,
          'additionalInfoCompleted': false,
        });

        // Send email verification
        await userCredential.user!.sendEmailVerification();

        Get.snackbar(
          'Success',
          'Account created successfully. Please verify your email.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during signup: $e');
      Get.snackbar(
        'Error',
        'Failed to create account. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      // Sign in to Firebase
      final userCredential = await firebase_auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Get.snackbar(
          'Success',
          'Logged in successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during signin: $e');
      Get.snackbar(
        'Error',
        'Failed to login. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset email sent',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send reset email: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}