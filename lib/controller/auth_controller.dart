import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final Rx<User?> user = Rx<User?>(null);

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await _auth.signInWithEmailAndPassword(
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
      userCredential = await _auth.createUserWithEmailAndPassword(
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
      // Create user account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestoreService.createUserDocument(
        name: name,
        email: email,
      );

      Get.snackbar(
        'Success',
        'Account created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error during signup: $e');
      Get.snackbar(
        'Error',
        'Failed to create account',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Logged in successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error during signin: $e');
      Get.snackbar(
        'Error',
        'Failed to sign in',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
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
        'Failed to sign out',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
