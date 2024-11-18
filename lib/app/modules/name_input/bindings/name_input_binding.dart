import 'package:get/get.dart';

import '../controllers/name_input_controller.dart';

class NameInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NameInputController>(
      () => NameInputController(),
    );
  }
}
