import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        borderRadius: 12,
        icon: const Icon(Icons.error, color: Colors.red),
        isDismissible: true,
      );

      return;
    }

    Future.delayed(Duration.zero, () {
      Get.snackbar(
        'Éxito',
        'Bienvenido $email',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        isDismissible: true,
      );
      resetFields();
      Get.offAllNamed('/homeowner');
    });
  }

  void goToRegister() {
    resetFields();
    Get.toNamed('/signup');
  }

  void resetFields() {
    emailController.clear();
    passwordController.clear();
  }
}
