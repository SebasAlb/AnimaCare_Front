import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controladores de los campos
  final email = ''.obs;
  final password = ''.obs;

  // Función dummy para el botón Ingresar
  void login() {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Simula un registro exitoso
    Future.delayed(Duration.zero, () {
      Get.snackbar(
        'Exíto',
        'Bienvenido ${email.value}',
        snackPosition: SnackPosition.TOP,
      );
      // Limpiar campos
      email.value = '';
      password.value = '';
      Get.toNamed('/recommendations');
    });
  }

  // Función para ir a registrar
  void goToRegister() {
    Get.toNamed('/signup');
  }
}
