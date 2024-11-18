import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/constants/app_color.dart';
import 'package:quiz_app/app/constants/app_font.dart';
import 'package:quiz_app/app/models/quiz_model.dart';
import 'package:quiz_app/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:quiz_app/app/routes/app_pages.dart';
import 'package:quiz_app/app/services/sqflite_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnswerQuizController extends GetxController {
  var questions = <QuestionOption>[].obs;
  var currentQuestionIndex = 0.obs;
  var score = 0.obs; // Skor yang didapat berdasarkan soal yang benar
  var selectedAnswerIndex = Rxn<int>();
  var isAnswerLocked = false.obs;
  var correctAnswerIndex = Rxn<int>();
  var playerName = ''.obs;

  var timeRemaining = 30.obs;
  var progress = 0.0.obs;
  Timer? timer;

  final LeaderboardController leaderboardController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _fetchQuestions();
    _loadPlayerName();
    _startTimer();
  }

  Future<void> _fetchQuestions() async {
    final questionsFromDb = await SqfliteService().getQuestionOptions();
    questions.assignAll(questionsFromDb);
    questions.shuffle(); // Mengacak urutan soal
  }

  Future<void> _loadPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    playerName.value = prefs.getString('user_name') ?? 'Anonymous';
  }

  void _startTimer() {
    timeRemaining.value = 30;
    progress.value = 0.0;

    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
        progress.value = 1 - (timeRemaining.value / 30);
      } else {
        nextQuestion();
      }
    });
  }

  void checkAnswer(int selectedIndex) {
    final question = questions[currentQuestionIndex.value];
    correctAnswerIndex.value = question.answerIndex;

    if (selectedIndex == question.answerIndex) {
      score.value += 10; // Tambah 10 poin per soal yang benar
    }

    isAnswerLocked.value = true;
  }

  void nextQuestion() async {
    if (timer != null) {
      timer!.cancel();
    }

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswerIndex.value = null;
      isAnswerLocked.value = false;
      correctAnswerIndex.value = null;
      _startTimer();
    } else {
      // Menambahkan nama dan skor ke leaderboard
      await leaderboardController.addToLeaderboard(playerName.value, score.value);
      showFinalScore();
    }
  }

  void showFinalScore() {
    // Menghitung total skor
    int maxScore = questions.length * 10; // Setiap soal bernilai 10 poin

    Get.defaultDialog(
      contentPadding: EdgeInsets.all(20),
      radius: 14,
      title: 'Quiz Completed',
      titleStyle: AppFont.bold.copyWith(
        fontSize: 20,
        color: AppColor.purple2,
      ),
      middleText: '${score.value} / $maxScore', // Menampilkan skor total
      middleTextStyle: AppFont.bold.copyWith(
        fontSize: 24,
        color: AppColor.purple2,
      ),
      textConfirm: 'OK',
      confirmTextColor: AppColor.white,
      onConfirm: () {
        Get.offAllNamed(Routes.HOME); // Navigasi ke halaman utama setelah konfirmasi
      },
      buttonColor: AppColor.purple1,
    );
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }
}
