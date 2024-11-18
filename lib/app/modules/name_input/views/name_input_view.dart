import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/components/custom_button.dart';
import 'package:quiz_app/app/components/custom_field.dart';
import 'package:quiz_app/app/constants/app_color.dart';
import 'package:quiz_app/app/constants/app_font.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import '../controllers/name_input_controller.dart';

class NameInputView extends GetView<NameInputController> {
  const NameInputView({super.key});

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
          'Input Name',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Lets Play Quiz',
                  style: AppFont.bold.copyWith(
                    fontSize: 28,
                    color: AppColor.white,
                  ),
                ),
                Text(
                  'Enter your information below',
                  style: AppFont.medium.copyWith(
                    fontSize: 14,
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(
                  height: 60.0,
                ),
                CustomField(
                  controller: controller.nameController,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                CustomButton(
                  onPressed: controller.checkAndSaveName,
                  text: 'Lets Start Quiz',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Obx(() {
                  // Tampilkan pesan error jika ada
                  if (controller.errorMessage.isNotEmpty) {
                    return Text(
                      controller.errorMessage.value,
                      style: AppFont.medium.copyWith(
                        fontSize: 14,
                        color: AppColor.red1,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
