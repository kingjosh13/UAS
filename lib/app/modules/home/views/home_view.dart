import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:quiz_app/app/components/custom_button.dart';
import 'package:quiz_app/app/constants/app_color.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import 'package:quiz_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.purple3,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AppImage.bg,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: () => Get.toNamed(Routes.NAME_INPUT),
                    text: 'Start Quiz',
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: () => Get.toNamed(Routes.CREATE_QUIZ),
                    text: 'Create Quiz',
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: () => Get.toNamed(Routes.LEADERBOARD),
                    text: 'Leaderboard',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
