import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/services/auth_service.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/storage/user_storage.dart';


class SignupController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signup() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final AuthService _authService = AuthService();

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

    try {
      final Dueno? newUser = await _authService.register(
        nombre: firstName,
        apellido: lastName,
        correo: email,
        contrasena: password,
      );

      if (newUser != null) {
        UserStorage.saveUser(newUser);
        Get.snackbar(
          'Registro exitoso',
          'Bienvenido ${newUser.nombre} ${newUser.apellido}!',
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          colorText: Colors.black,
          borderRadius: 12,
        );
        resetFields();
        Get.offAllNamed('/homeowner');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.error, color: Colors.red),
        colorText: Colors.black,
        borderRadius: 12,
      );
    }
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
