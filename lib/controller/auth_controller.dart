import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';


class AuthController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
      userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
}
