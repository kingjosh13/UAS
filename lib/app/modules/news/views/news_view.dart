import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quiz_app/app/models/news_model.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_font.dart';
import '../controllers/news_controller.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
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
          'News API',
          style: AppFont.bold.copyWith(
            color: AppColor.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.purple1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        } else {
          return ListView.builder(
            itemCount: controller.kumparanNews.length,
            itemBuilder: (context, index) {
              final KumparanNews news = controller.kumparanNews[index];

              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), // Border radius untuk gambar
                      ),
                      child: Stack(
                        children: [
                          // Gambar sebagai latar belakang
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              news.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            bottom: 8,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                news.creator,
                                style: AppFont.semiBold.copyWith(
                                  color: AppColor.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title,
                            style: AppFont.semiBold.copyWith(
                              color: AppColor.purple3,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            news.description,
                            style: AppFont.regular.copyWith(
                              color: AppColor.purple3,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
