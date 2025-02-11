import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Widget commonCard({
  double? width,
  double? height,
  required String text,
  VoidCallback? ontap,
  double horizontal = 0.0, // ✅ Default value to avoid errors
  double vertical = 0.0,   // ✅ Default value to avoid errors
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: GestureDetector(
        onTap: ontap,
        child: Row(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Vx.gray300,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Vx.gray400, // Change color as needed
                  width: 1, // Border thickness
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

            )
          ],
        )
    ),
  );
}
