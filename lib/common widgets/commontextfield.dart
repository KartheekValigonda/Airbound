import 'package:flutter/material.dart';

Widget commonTextfield({hinttext, obstxt, height, width, controller }){
  return Container(
    width: width ,
    height: height,
    child: TextField(
      controller: controller,
      obscureText: obstxt,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: const TextStyle(color: Colors.white),
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
    ),
  );
}