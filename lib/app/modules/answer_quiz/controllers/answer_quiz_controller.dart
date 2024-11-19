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
  var questions = <dynamic>[].obs; // Menyimpan soal gabungan pilihan ganda dan esai
  var currentQuestionIndex = 0.obs;
  var score = 0.obs; // Skor yang didapat berdasarkan soal yang benar
  var selectedAnswerIndex = Rxn<int>(); // Jawaban untuk soal pilihan ganda
  var essayAnswer = ''.obs; // Jawaban untuk soal esai
  var isAnswerLocked = false.obs;
  var correctAnswerIndex = Rxn<int>();
  var playerName = ''.obs;
  // Variabel untuk menandakan apakah input esai bisa diubah
  var isEssayReadOnly = false.obs; // Defaultnya editable
  // var correctEssay = '';
  var correctEssay = false.obs;

  var timeRemaining = 30.obs;
  var progress = 0.0.obs;
  Timer? timer;

  // TextEditingController untuk esai
  TextEditingController essayController = TextEditingController();
  final LeaderboardController leaderboardController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _fetchQuestions(); // Ambil soal dan acak sebelum digabung
    _loadPlayerName();
    _startTimer();
  }

  // Ambil soal pilihan ganda dan esai, acak, kemudian gabungkan
  Future<void> _fetchQuestions() async {
    // Ambil soal pilihan ganda
    final questionsFromDbOption = await SqfliteService().getQuestionOptions();

    // Ambil soal esai
    final questionsFromDbEssay = await SqfliteService().getQuestionEssays();

    // Acak soal pilihan ganda dan soal esai secara terpisah
    questionsFromDbOption.shuffle();
    questionsFromDbEssay.shuffle();

    // Gabungkan soal pilihan ganda dan soal esai
    questions.assignAll([...questionsFromDbOption, ...questionsFromDbEssay]);
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

  // Menilai jawaban pilihan ganda dan esai
  void checkAnswer(int selectedIndex) {
    final question = questions[currentQuestionIndex.value];

    if (question is QuestionOption) {
      // Penilaian soal pilihan ganda
      correctAnswerIndex.value = question.answerIndex;
      if (selectedIndex == question.answerIndex) {
        score.value += 10; // Tambah 10 poin jika jawaban benar
      }
    } else if (question is QuestionEssay) {
      // Penilaian soal esai
      final answer = essayAnswer.value.trim().toLowerCase();
      final correctAnswer = question.answerKey.trim().toLowerCase();

      if (answer.isNotEmpty && correctAnswer.contains(answer)) {
        score.value += 10;
        // correctEssay = 'Jawaban Benar';
        correctEssay.value = true;
      } else {
        // correctEssay = 'Jawaban Salah';
        correctEssay.value = false;
      }
    }

    isAnswerLocked.value = true;
    // Set isEssayEditable to false after checking answer
    isEssayReadOnly.value = true; // Lock essay field
  }

  // Pindah ke soal berikutnya
  void nextQuestion() async {
    if (timer != null) {
      timer!.cancel();
    }

    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswerIndex.value = null;
      essayAnswer.value = ''; // Reset jawaban esai
      // correctEssay = '';
      correctEssay.value = false;
      essayController.clear();
      isEssayReadOnly.value = false;
      isAnswerLocked.value = false;
      correctAnswerIndex.value = null;
      _startTimer();
    } else {
      // Menambahkan nama dan skor ke leaderboard
      await leaderboardController.addToLeaderboard(playerName.value, score.value);
      showFinalScore();
    }
  }

  // Menampilkan skor akhir
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
