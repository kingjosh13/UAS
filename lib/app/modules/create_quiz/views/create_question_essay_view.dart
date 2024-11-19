import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/components/custom_button.dart';
import 'package:quiz_app/app/components/custom_field.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import 'package:quiz_app/app/modules/create_quiz/controllers/create_quiz_controller.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_font.dart';

class CreateQuestionEssayView extends GetView<CreateQuizController> {
  const CreateQuestionEssayView({super.key});

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
          'Question Essay',
          style: AppFont.bold.copyWith(
            color: AppColor.white,
            fontSize: 18,
          ),
        ),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomField(
                    label: 'Question',
                    onChanged: (value) {
                      controller.questionText.value = value;
                    },
                    maxLine: 4,
                  ),

                  CustomField(
                    label: 'Answer Key',
                    onChanged: (value) {
                      controller.essayAnswer.value = value;
                    },
                    maxLine: 5,
                  ),

                  const SizedBox(height: 40),

                  // Tombol untuk menyimpan pertanyaan essay
                  CustomButton(
                    onPressed: controller.addEssayQuestion,
                    text: 'Add Question',
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
