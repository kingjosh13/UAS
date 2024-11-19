import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/components/custom_button.dart';
import 'package:quiz_app/app/components/custom_field.dart';
import 'package:quiz_app/app/constants/app_color.dart';
import 'package:quiz_app/app/constants/app_font.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import 'package:quiz_app/app/models/quiz_model.dart';
import '../controllers/answer_quiz_controller.dart';

class AnswerQuizView extends GetView<AnswerQuizController> {
  const AnswerQuizView({super.key});

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (controller.questions.isEmpty) {
                return const Center(child: Text('No questions available'));
              }

              final question = controller.questions[controller.currentQuestionIndex.value];
              final currentQuestionNumber = controller.currentQuestionIndex.value + 1;
              final totalQuestions = controller.questions.length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.close, color: AppColor.white),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.purple1,
                        ),
                        child: Text(
                          '${controller.timeRemaining.value}',
                          style: AppFont.semiBold.copyWith(color: AppColor.white, fontSize: 14),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentQuestionNumber',
                              style: AppFont.semiBold.copyWith(color: AppColor.white, fontSize: 16),
                            ),
                            TextSpan(
                              text: '/$totalQuestions',
                              style: AppFont.semiBold.copyWith(color: AppColor.grey1, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    question.question,
                    style: AppFont.bold.copyWith(color: AppColor.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  if (question is QuestionOption)
                    ...question.options.asMap().entries.map((entry) {
                      int index = entry.key;
                      String option = entry.value;

                      Color borderColor = AppColor.grey1;
                      String iconOption = AppImage.icOptionEmpty;
                      Color bgOption = AppColor.purple2;

                      if (controller.isAnswerLocked.value) {
                        if (index == controller.correctAnswerIndex.value) {
                          borderColor = AppColor.green1; // Jawaban benar
                          bgOption = AppColor.green2;
                          iconOption = AppImage.icOptionCorrect;
                        } else if (index == controller.selectedAnswerIndex.value) {
                          borderColor = AppColor.red1; // Jawaban salah
                          iconOption = AppImage.icOptionFailed;
                          bgOption = AppColor.red2;
                        }
                      } else {
                        if (controller.selectedAnswerIndex.value == index) {
                          borderColor = AppColor.purple1; // Jawaban dipilih
                          iconOption = AppImage.icOptionActive;
                          bgOption = AppColor.purple2;
                        }
                      }

                      return GestureDetector(
                        onTap: controller.isAnswerLocked.value
                            ? null
                            : () {
                                controller.selectedAnswerIndex.value = index;
                              },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: bgOption,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: AppFont.bold.copyWith(
                                  color: AppColor.white,
                                  fontSize: 14,
                                ),
                              ),
                              SvgPicture.asset(iconOption),
                            ],
                          ),
                        ),
                      );
                    }),
                  if (question is QuestionEssay) ...[
                    // Menampilkan CustomField hanya untuk soal esai
                    CustomField(
                      controller: controller.essayController,
                      onChanged: (value) {
                        controller.essayAnswer.value = value;
                      },
                      maxLine: 4,
                      readOnly: controller.isEssayReadOnly.value, // Menyeting agar field menjadi read-only setelah dijawab
                    ),
                    // Menampilkan hasil jawaban untuk soal esai: "Jawaban Benar" atau "Jawaban Salah"
                    if (controller.isAnswerLocked.value) // Hanya tampilkan setelah jawaban dikunci
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.correctEssay.value ? 'Benar' : 'Salah',
                            style: AppFont.bold.copyWith(
                              color: controller.correctEssay.value ? AppColor.green1 : AppColor.red1, // Warna hijau untuk benar, merah untuk salah
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          SvgPicture.asset(
                            controller.correctEssay.value ? AppImage.icOptionCorrect : AppImage.icOptionFailed,
                            width: 28,
                            height: 28,
                          )
                        ],
                      ),
                  ],
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: controller.selectedAnswerIndex.value != null || controller.essayAnswer.isNotEmpty
                        ? CustomButton(
                            onPressed: controller.isAnswerLocked.value
                                ? controller.nextQuestion
                                : () {
                                    if (controller.selectedAnswerIndex.value != null || controller.essayAnswer.isNotEmpty) {
                                      controller.checkAnswer(controller.selectedAnswerIndex.value ?? -1);
                                    }
                                  },
                            text: controller.isAnswerLocked.value ? 'Next Question' : 'Lock Answer',
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
