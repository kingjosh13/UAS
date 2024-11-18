import 'package:flutter/material.dart';
import 'package:quiz_app/app/constants/app_color.dart';

import '../constants/app_font.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final double height;
  final double radius;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 52,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.purple1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppFont.bold.copyWith(
            fontSize: 14,
            color: AppColor.white,
          ),
        ),
      ),
    );
  }
}
