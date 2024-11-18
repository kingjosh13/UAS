import 'package:get/get.dart';

import '../controllers/create_quiz_controller.dart';

class CreateQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateQuizController>(
      () => CreateQuizController(),
    );
  }
}
