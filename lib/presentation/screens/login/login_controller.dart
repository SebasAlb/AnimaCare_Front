import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/services/auth_service.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/storage/user_storage.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void login() async {
    final String correo = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      _showSnackbar('Error', 'Por favor, completa todos los campos.', isError: true);
      return;
    }

    try {
      final Dueno? user = await _authService.login(correo, password);
      if (user != null) {
        UserStorage.saveUser(user);
        _showSnackbar('Éxito', 'Bienvenido ${user.nombre} ${user.apellido}');
        resetFields();
        Get.offAllNamed('/homeowner');
      }
    } catch (e) {
      _showSnackbar('Error', e.toString(), isError: true);
    }
  }

  void goToRegister() {
    resetFields();
    Get.toNamed('/signup');
  }

  void resetFields() {
    emailController.clear();
    passwordController.clear();
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message.replaceAll('Exception: ', ''),
      snackPosition: (isError ? SnackPosition.BOTTOM : SnackPosition.TOP),
      colorText: Colors.black,
      icon: Icon(isError ? Icons.error : Icons.check_circle, color: isError ? Colors.red : Colors.green),
    );
  }
}
