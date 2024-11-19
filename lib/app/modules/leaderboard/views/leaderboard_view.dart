import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/constants/app_color.dart';
import 'package:quiz_app/app/constants/app_font.dart';
import 'package:quiz_app/app/constants/app_image.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Leaderboard',
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
            if (controller.leaderboard.isEmpty) {
              return Center(
                child: Text(
                  'No leaderboard data',
                  style: AppFont.bold.copyWith(
                    color: AppColor.white,
                    fontSize: 18,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: controller.leaderboard.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16.0),
              itemBuilder: (context, index) {
                final data = controller.leaderboard[index];
                // Menentukan medali berdasarkan peringkat
                String medalPath;
                if (index == 0) {
                  medalPath = AppImage.medalFirst; // Medali emas untuk peringkat pertama
                } else if (index == 1) {
                  medalPath = AppImage.medalSecond; // Medali perak untuk peringkat kedua
                } else if (index == 2) {
                  medalPath = AppImage.medalThird; // Medali perunggu untuk peringkat ketiga
                } else {
                  medalPath = ''; // Tidak ada medali untuk peringkat di luar 3 besar
                }
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.purple1,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.purple3,
                            width: 3,
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: AppFont.bold.copyWith(
                            color: AppColor.purple3,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: AppFont.bold.copyWith(
                              color: AppColor.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            '${data['score']} Points',
                            style: AppFont.medium.copyWith(
                              color: AppColor.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Menampilkan medali berdasarkan urutan
                      if (medalPath.isNotEmpty)
                        SvgPicture.asset(
                          medalPath,
                        ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
