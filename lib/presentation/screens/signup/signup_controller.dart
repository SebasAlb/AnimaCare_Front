import 'package:get/get.dart';

class SignupController extends GetxController {
  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  void signup() {
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
        'Registro',
        'Usuario registrado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  void goBack() {
    Get.back();
  }
}
