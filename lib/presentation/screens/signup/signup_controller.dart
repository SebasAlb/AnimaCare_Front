import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signup() {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

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
