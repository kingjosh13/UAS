import 'package:get/get.dart';

import '../../leaderboard/controllers/leaderboard_controller.dart';
import '../controllers/answer_quiz_controller.dart';

class AnswerQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnswerQuizController>(
      () => AnswerQuizController(),
    );
    Get.lazyPut<LeaderboardController>(
      () => LeaderboardController(),
    );
  }
}
