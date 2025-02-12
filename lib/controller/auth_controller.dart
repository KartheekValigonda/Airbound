import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';


class AuthController extends GetxController{

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  //login method
  Future<UserCredential?> loginMethod({context}) async{
    UserCredential? userCredential;

    try{
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
    } on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }

    return userCredential;
  }


  //signup method
  Future<UserCredential?> signupMethod({name, email, password, context}) async{
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      await storeUserData(name: name, email: email, password: password);
    } on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }


  //storing data
  Future<void> storeUserData({name, email, password}) async{
    DocumentReference store = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
    await store.set({
      'name': name,
      'email': email,
      'password': password,
    });
  }

  //logout method
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Show a toast using Get.context (ensure Get.context is not null)
      VxToast.show(Get.context!, msg: "Successfully logged out");
    } catch (e) {
      VxToast.show(Get.context!, msg: 'Logout failed: ${e.toString()}');
    }
  }
}
