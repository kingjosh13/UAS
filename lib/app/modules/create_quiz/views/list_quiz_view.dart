import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/constants/app_color.dart';
import 'package:quiz_app/app/constants/app_font.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import 'package:quiz_app/app/models/quiz_model.dart';
import 'package:quiz_app/app/modules/create_quiz/controllers/create_quiz_controller.dart';

class ListQuizView extends GetView<CreateQuizController> {
  const ListQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memuat pertanyaan pilihan ganda dan soal esai
    controller.loadOptionQuestions();
    controller.loadEssayQuestions();

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
          'List Questions',
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
          Positioned.fill(
            child: SvgPicture.asset(
              AppImage.bg,
              fit: BoxFit.cover,
            ),
          ),
          Obx(() {
            // Gabungkan soal pilihan ganda dan soal esai
            final allQuestions = [...controller.questions, ...controller.essayQuestions];

            if (allQuestions.isEmpty) {
              return Center(
                child: Text(
                  'No Data Questions',
                  style: AppFont.bold.copyWith(
                    color: AppColor.white,
                    fontSize: 20,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: allQuestions.length,
              padding: EdgeInsets.all(20),
              separatorBuilder: (context, index) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final question = allQuestions[index];

                if (question is QuestionOption) {
                  // Menampilkan soal pilihan ganda
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.purple1,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${question.question}',
                          style: AppFont.bold.copyWith(
                            color: AppColor.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Menampilkan pilihan jawaban untuk setiap pertanyaan
                        ...List.generate(question.options.length, (optIndex) {
                          String optionLabel = String.fromCharCode(65 + optIndex); // A = 65 di ASCII
                          return Text(
                            '$optionLabel. ${question.options[optIndex]}',
                            style: AppFont.semiBold.copyWith(
                              color: AppColor.white,
                              fontSize: 14,
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        Text(
                          'Correct Answer: ${String.fromCharCode(65 + question.answerIndex)}',
                          style: AppFont.semiBold.copyWith(
                            color: AppColor.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (question is QuestionEssay) {
                  // Menampilkan soal esai
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.purple1,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${question.question}',
                          style: AppFont.bold.copyWith(
                            color: AppColor.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Menampilkan petunjuk bahwa ini soal esai
                        Text(
                          'Answer Key: ${question.answerKey}',
                          style: AppFont.semiBold.copyWith(
                            color: AppColor.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Return empty container as fallback (optional)
                return Container();
              },
            );
          }),
        ],
      ),
    );
  }
}
