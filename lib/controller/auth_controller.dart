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
  Future<UserCredential?> signupMethod({name, email, gender, phone, password, context}) async{
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      await storeUserData(name: name, email: email, gender: gender, phone: phone, password: password);
    } on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }


  //storing data
  Future<void> storeUserData({name, email, gender, phone, password}) async{
    DocumentReference store = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
    await store.set({
      'name': name,
      'email': email,
      'gender': gender,
      'password': password,
    });
  }


  //logout method
  Future<void> logoutMethod({context}) async{
    try{
      await FirebaseAuth.instance.signOut();
      VxToast.show(context, msg: "successfully logout");
    }catch(e){
      VxToast.show(context, msg: 'Log out failed: ${e.toString()}');
    }
  }


  //reset password method
  Future<void> sendPasswordResetLink({email,context}) async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  //check email is registered or not
  Future<bool> checkUserExistence({email}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users') // Assuming you have a 'users' collection
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }


}