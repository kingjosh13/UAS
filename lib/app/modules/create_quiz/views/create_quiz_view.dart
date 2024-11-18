import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/components/custom_button.dart';
import 'package:quiz_app/app/components/custom_field.dart';
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

                  // Menampilkan input untuk 4 opsi jawaban
                  ...List.generate(4, (index) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomField(
                            label: 'Option ${index + 1}',
                            onChanged: (value) {
                              controller.updateOption(index, value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                          ),
                          child: Obx(() {
                            return InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () {
                                controller.selectedAnswerIndex.value = index;
                              },
                              child: SvgPicture.asset(
                                controller.selectedAnswerIndex.value == index ? AppImage.icOptionCorrect : AppImage.icOptionEmpty,
                                width: 28,
                                height: 28,
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 40),

                  // Tombol untuk menyimpan pertanyaan
                  CustomButton(
                    onPressed: controller.addQuestion,
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
