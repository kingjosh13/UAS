import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/app/routes/app_pages.dart';

class NameInputController extends GetxController {
  var nameController = TextEditingController();
  var errorMessage = ''.obs; // Untuk menampilkan pesan error jika nama sudah ada

  // Fungsi untuk memeriksa dan menyimpan nama
  Future<void> checkAndSaveName() async {
    String enteredName = nameController.text.trim();

    if (enteredName.isEmpty) {
      errorMessage.value = 'Please enter your name!';
      return;
    }

    // Ambil daftar nama yang sudah digunakan menggunakan SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> usedNames = prefs.getStringList('used_names') ?? [];

    // Mengubah semua nama menjadi huruf kecil sebelum melakukan perbandingan
    if (usedNames.any((name) => name.toLowerCase() == enteredName.toLowerCase())) {
      errorMessage.value = 'This name is already taken, please choose another one!';
    } else {
      // Menambahkan nama ke daftar nama yang digunakan
      usedNames.add(enteredName);

      // Simpan kembali daftar nama yang sudah digunakan ke SharedPreferences
      await prefs.setStringList('used_names', usedNames);

      // Menyimpan nama pengguna untuk digunakan di AnswerQuiz
      await prefs.setString('user_name', enteredName);

      // Menghilangkan fokus dari TextField setelah menyimpan data
      FocusScope.of(Get.context!).unfocus();

      // Navigasi ke halaman quiz setelah nama disimpan
      Get.toNamed(Routes.ANSWER_QUIZ);
    }
  }
}
