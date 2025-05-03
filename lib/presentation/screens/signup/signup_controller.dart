import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signup() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        borderRadius: 12,
        icon: const Icon(Icons.error, color: Colors.red),
        duration: const Duration(seconds: 3),
        isDismissible: true,
      );
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar(
        'Error',
        'Por favor, asegúrate de que las contraseñas coincidan.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        borderRadius: 12,
        icon: const Icon(Icons.error, color: Colors.red),
        duration: const Duration(seconds: 3),
        isDismissible: true,
      );
      return;
    }

    Future.delayed(Duration.zero, () {
      Get.snackbar(
        'Registro',
        'Usuario registrado correctamente',
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 3),
        isDismissible: true,
      );
      resetFields();
      Get.offAllNamed('/recommendations');
    });
  }

  void resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void goBack() {
    resetFields();
    Get.back();
  }
}
