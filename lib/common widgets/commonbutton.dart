import 'package:airbound/Theme/color_pallet.dart';
import 'package:flutter/material.dart';

Widget commonButton({onNavigate,buttonName, width, height, clr, txtclr}){
  return ElevatedButton(
    onPressed: onNavigate,
    style: ElevatedButton.styleFrom(
      backgroundColor: clr,
      foregroundColor: Colors.white70, // Text color
      shape: RoundedRectangleBorder(
        side: const BorderSide(
            color: Pallete.authButton
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      fixedSize: Size(width, height),
    ),
    child: Text(buttonName, style: TextStyle(fontSize: 18, color: txtclr)),
  );
}