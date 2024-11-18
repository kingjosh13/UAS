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
  var questions = <Question>[].obs;

  // Update opsi yang dipilih (index untuk menandai)
  void updateOption(int index, String value) {
    if (index >= 0 && index < 4) {
      options[index] = value;
    }
  }

  // Menambah pertanyaan ke database
  Future<void> addQuestion() async {
    if (questionText.value.isNotEmpty && options.every((option) => option.isNotEmpty) && selectedAnswerIndex.value != null) {
      final newQuestion = Question(
        question: questionText.value,
        options: options.toList(),
        answerIndex: selectedAnswerIndex.value!, // karna perlu ini
      );

      // Menyimpan pertanyaan ke database
      await SqfliteService().insertQuestion(newQuestion);
      Get.snackbar('Success', 'Question added successfully');

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

  // Fungsi untuk memuat semua pertanyaan dari database
  Future<void> loadQuestions() async {
    final dbHelper = SqfliteService();
    final questionList = await dbHelper.getQuestions(); // Ambil data pertanyaan dari database
    questions.assignAll(questionList); // Assign ke RxList questions yang ada di controller
  }
}
