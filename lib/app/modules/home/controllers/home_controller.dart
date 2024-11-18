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
      // Membaca file JSON dari assets
      String jsonString = await rootBundle.loadString('assets/quiz.json');
      List<dynamic> jsonList = json.decode(jsonString);

      // Log untuk memastikan data JSON yang dimuat
      log('Loaded JSON data: $jsonList');

      // Menyusun data menjadi format Question dan menyimpannya ke SQLite
      for (var e in jsonList) {
        Question question = Question(
          question: e['question'],
          options: List<String>.from(e['options']),
          answerIndex: e['answer_index'],
        );

        // Cek apakah soal sudah ada di database
        bool exists = await SqfliteService().checkIfQuestionExists(question.question);
        if (!exists) {
          // Simpan ke database SQLite jika soal belum ada
          await SqfliteService().insertQuestion(question);
          log('Saved Question to SQLite: ${question.question}');
        } else {
          log('Question already exists in database: ${question.question}');
        }
      }

      log('Quiz data has been loaded and saved to SQLite!');
    } catch (e) {
      log('Error loading and saving quiz data: $e');
    }
  }
}
