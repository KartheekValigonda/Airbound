import 'package:flutter/material.dart';

Widget commonTextfield({
  String? hinttext,
  bool? obstxt,
  double? height,
  double? width,
  TextEditingController? controller,
  TextInputType? keyboardType,
  String? Function(String?)? validator
}) {
  return Container(
    width: width,
    height: height,
    child: TextFormField(
      controller: controller,
      obscureText: obstxt ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white60), // Border color when enabled
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.0), // Border color when focused
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: validator,
    ),
  );
}