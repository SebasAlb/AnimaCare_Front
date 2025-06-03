import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/services/auth_service.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/storage/user_storage.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  var obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final theme = Theme.of(Get.context!);

  void login() async {
    final String correo = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (correo.isEmpty || password.isEmpty) {
      SoundService.playWarning();
      Get.snackbar(
        'Campos requeridos',
        'Por favor, completa todos los campos.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    if (!correo.contains('@')) {
      SoundService.playWarning();
      Get.snackbar(
        'Correo inválido',
        'El correo debe contener el carácter "@".',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }
    isLoading.value = true;

    try {
      final Dueno? user = await _authService.login(correo, password);
      if (user != null) {
        SoundService.playSuccess();
        UserStorage.saveUser(user);
        Get.snackbar(
          'Inicio de sesión exitoso',
          'Bienvenido ${user.nombre} ${user.apellido}',
          backgroundColor: Colors.white30,
          colorText: theme.colorScheme.onBackground,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        resetFields();
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed('/homeowner');
      }
    } catch (e) {
      SoundService.playWarning();
      Get.snackbar(
        'Error',
        'Ocurrió un error inesperado.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void goToRegister() {
    SoundService.playButton();
    resetFields();
    Get.toNamed('/signup');
  }

  void resetFields() {
    emailController.clear();
    passwordController.clear();
  }
}
