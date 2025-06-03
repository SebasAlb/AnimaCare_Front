import 'package:animacare_front/services/sound_service.dart';
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
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  final TextEditingController cedulaController = TextEditingController();
  final RxBool isLoading = false.obs;

  void signup() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final theme = Theme.of(Get.context!);
    final AuthService _authService = AuthService();
    final String cedula = cedulaController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    // Validaciones específicas
    if (firstName.length > 60) {
      SoundService.playWarning();
      Get.snackbar(
        'Validación',
        'Nombre no debe superar los 60 caracteres.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    if (lastName.length > 60) {
      SoundService.playWarning();
      Get.snackbar(
        'Validación',
        'Apellido no debe superar los 60 caracteres.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    if (cedula.isEmpty) {
      SoundService.playWarning();
      Get.snackbar(
        'Campo requerido',
        'Por favor, ingresa tu cédula.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(cedula)) {
      SoundService.playWarning();
      Get.snackbar(
        'Cédula inválida',
        'La cédula debe contener exactamente 10 dígitos numéricos.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }


    if (!email.contains('@')) {
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

    if (password.length < 6) {
      SoundService.playWarning();
      Get.snackbar(
        'Contraseña inválida',
        'La contraseña debe tener al menos 6 caracteres.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    if (password != confirmPassword) {
      SoundService.playWarning();
      Get.snackbar(
        'Contraseñas no coinciden',
        'Por favor, asegúrate de que las contraseñas sean iguales.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }
    isLoading.value = true;
    try {
      final Dueno? newUser = await _authService.register(
        nombre: firstName,
        apellido: lastName,
        cedula: cedula,
        correo: email,
        contrasena: password,
      );

      if (newUser != null) {
        SoundService.playSuccess();
        UserStorage.saveUser(newUser);
        Get.snackbar(
          'Registro exitoso',
          'Bienvenido ${newUser.nombre} ${newUser.apellido}',
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
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
    } finally {
      isLoading.value = false;
    }
  }


  void togglePasswordVisibility() {
    SoundService.playButton();
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    SoundService.playButton();
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    cedulaController.clear();
  }

  void goBack() {
    SoundService.playButton();
    resetFields();
    Get.back();
  }
}
