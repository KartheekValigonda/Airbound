import 'package:flutter/material.dart';
import '../Theme/color_pallet.dart';

Widget commonTextfield({
  String? hinttext,
  bool? obstxt,
  double? height,
  double? width,
  TextEditingController? controller,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  context
}) {
  return Container(
    width: width,
    height: height,
    child: TextFormField(
      style: Theme.of(context).textTheme.bodySmall,
      controller: controller,
      obscureText: obstxt ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Pallete.authButton), // Border color when enabled
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Pallete.authButton, width: 1.0), // Border color when focused
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: validator,
    ),
  );
}