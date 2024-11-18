import 'package:get/get.dart';
import 'package:quiz_app/app/models/quiz_model.dart';
import 'package:quiz_app/app/routes/app_pages.dart';
import 'package:quiz_app/app/services/sqflite_service.dart';

class CreateQuizController extends GetxController {
  // Menyimpan pertanyaan, opsi, dan jawaban yang dipilih
  var questionText = ''.obs;
  var options = List<String>.generate(4, (index) => '').obs; // 4 opsi jawaban
  var selectedAnswerIndex = Rxn<int>(); // Jawaban yang dipilih sebagai benar

  // Daftar pertanyaan yang sudah ada
  var questions = <QuestionOption>[].obs;
  var essayQuestions = <QuestionEssay>[].obs; // Menambahkan daftar soal esai

  // Update opsi yang dipilih (index untuk menandai)
  void updateOption(int index, String value) {
    if (index >= 0 && index < 4) {
      options[index] = value;
    }
  }

  // Menambah pertanyaan pilihan ganda ke database
  Future<void> addOptionQuestion() async {
    if (questionText.value.isNotEmpty && options.every((option) => option.isNotEmpty) && selectedAnswerIndex.value != null) {
      final newQuestion = QuestionOption(
        question: questionText.value,
        options: options.toList(),
        answerIndex: selectedAnswerIndex.value!, // Karena perlu ini
      );

      // Menyimpan pertanyaan ke database
      await SqfliteService().insertQuestionOption(newQuestion);
      Get.snackbar('Success', 'Question added successfully');

      // Reset form setelah menambah pertanyaan
      resetForm();
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }

  // Menambah soal esai ke database
  Future<void> addEssayQuestion(String answerKey) async {
    if (questionText.value.isNotEmpty && answerKey.isNotEmpty) {
      final newEssayQuestion = QuestionEssay(
        question: questionText.value,
        answerKey: answerKey,
      );

      // Menyimpan soal esai ke database
      await SqfliteService().insertQuestionEssay(newEssayQuestion);
      Get.snackbar('Success', 'Essay question added successfully');

      // Reset form setelah menambah pertanyaan
      resetForm();
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }

  // Reset form untuk input baru
  void resetForm() {
    questionText.value = '';
    options.fillRange(0, 4, ''); // Reset semua opsi
    selectedAnswerIndex.value = null;
  }

  // Fungsi untuk memuat semua pertanyaan pilihan ganda dari database
  Future<void> loadOptionQuestions() async {
    final dbHelper = SqfliteService();
    final questionList = await dbHelper.getQuestionOptions(); // Ambil data pertanyaan pilihan ganda dari database
    questions.assignAll(questionList); // Assign ke RxList questions yang ada di controller
  }

  // Fungsi untuk memuat semua pertanyaan esai dari database
  Future<void> loadEssayQuestions() async {
    final dbHelper = SqfliteService();
    final essayQuestionList = await dbHelper.getQuestionEssays(); // Ambil data pertanyaan esai dari database
    essayQuestions.assignAll(essayQuestionList); // Assign ke RxList essayQuestions yang ada di controller
  }
}
