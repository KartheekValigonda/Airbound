import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Something went wrong",
          backgroundColor: Colors.black45, colorText: Colors.white);
    }

    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({name, email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      await storeUserData(name: name, email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storing data
  Future<void> storeUserData({name, email, password}) async {
    DocumentReference store = FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await store.set({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  // email verification
  Future<void> sendEmailVerification({context}) async{
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
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
        await _firestoreService.createUserDocument(
          uid: uid,
          name: name,
          email: email,
        );

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
      // Sign out from Firebase
      await firebase_auth.FirebaseAuth.instance.signOut();

      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error during signout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Send reset email from Firebase
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      Get.snackbar(
        'Success',
        'Password reset email sent',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error during password reset: $e');
      Get.snackbar(
        'Error',
        'Failed to send reset email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
}
