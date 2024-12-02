import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Fungsi untuk login
  Future<void> login() async {
    isLoading.value = true;
    try {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        Get.snackbar("Error", "Username and password cannot be empty!",
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
        return;
      }

      if (username.length < 3) {
        Get.snackbar("Error", "Username must be at least 3 characters!",
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
        return;
      }

      if (password.length < 6) {
        Get.snackbar("Error", "Password must be at least 6 characters!",
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
        return;
      }

      // Validasi dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedUsername = prefs.getString("username");
      String? savedPassword = prefs.getString("password");

      if (username == savedUsername && password == savedPassword) {
        // Pindah ke halaman berikutnya
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar("Error", "Invalid username or password!",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout (opsional jika diperlukan)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
  }
}
