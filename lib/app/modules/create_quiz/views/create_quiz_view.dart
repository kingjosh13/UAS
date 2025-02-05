import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/components/custom_button.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import 'package:quiz_app/app/modules/create_quiz/controllers/create_quiz_controller.dart';
import 'package:quiz_app/app/routes/app_pages.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_font.dart';

class CreateQuizView extends GetView<CreateQuizController> {
  const CreateQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.purple3,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.white,
          ),
        ),
        title: Text(
          'Create Quiz',
          style: AppFont.bold.copyWith(
            color: AppColor.white,
            fontSize: 18,
          ),
        ),
        actions: [
          // Tombol untuk menuju ke daftar pertanyaan
          IconButton(
            onPressed: () => Get.toNamed(Routes.LIST_QUIZ),
            icon: Icon(
              Icons.history,
              color: AppColor.white,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: AppColor.purple1,
      ),
      body: Stack(
        children: [
          SvgPicture.asset(
            AppImage.bg,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: () => Get.toNamed(Routes.CREATE_QUESTION_OPTION),
                    text: 'Create Question Option',
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    onPressed: () => Get.toNamed(Routes.CREATE_QUESTION_ESSAY),
                    text: 'Create Question Essay',
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
