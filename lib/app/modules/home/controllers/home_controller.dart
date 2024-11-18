import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/models/quiz_model.dart';
import 'package:quiz_app/app/services/sqflite_service.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadAndSaveQuizData(); // Memuat dan menyimpan data quiz ke SQLite
  }

  // Fungsi untuk memuat data dari JSON dan menyimpannya ke SQLite
  Future<void> loadAndSaveQuizData() async {
    try {
      // Membaca file JSON untuk soal pilihan ganda (quiz_option.json)
      String jsonOptionString = await rootBundle.loadString('assets/quiz_option.json');
      List<dynamic> jsonOptionList = json.decode(jsonOptionString);

      // Membaca file JSON untuk soal esai (quiz_essay.json)
      String jsonEssayString = await rootBundle.loadString('assets/quiz_essay.json');
      List<dynamic> jsonEssayList = json.decode(jsonEssayString);

      // Log untuk memastikan data JSON yang dimuat
      log('Loaded Option JSON data: $jsonOptionList');
      log('Loaded Essay JSON data: $jsonEssayList');

      // Proses soal pilihan ganda
      for (var e in jsonOptionList) {
        QuestionOption question = QuestionOption(
          question: e['question'],
          options: List<String>.from(e['options']),
          answerIndex: e['answer_index'],
        );

        // Cek apakah soal sudah ada di database
        bool exists = await SqfliteService().checkIfQuestionExists(question.question, false);
        if (!exists) {
          // Simpan ke database SQLite jika soal belum ada
          await SqfliteService().insertQuestionOption(question);
          log('Saved Option Question to SQLite: ${question.question}');
        } else {
          log('Option Question already exists in database: ${question.question}');
        }
      }

      // Proses soal esai
      for (var e in jsonEssayList) {
        QuestionEssay question = QuestionEssay(
          question: e['question'],
          answerKey: e['answerKey'],
        );

        // Cek apakah soal sudah ada di database
        bool exists = await SqfliteService().checkIfQuestionExists(question.question, true);
        if (!exists) {
          // Simpan ke database SQLite jika soal belum ada
          await SqfliteService().insertQuestionEssay(question);
          log('Saved Essay Question to SQLite: ${question.question}');
        } else {
          log('Essay Question already exists in database: ${question.question}');
        }
      }

      log('Quiz data has been loaded and saved to SQLite!');
    } catch (e) {
      log('Error loading and saving quiz data: $e');
      rethrow; // Optional: Rethrow error jika ingin error ditangani di tempat lain
    }
  }
}
