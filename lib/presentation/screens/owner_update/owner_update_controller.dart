import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerUpdateController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveUserInfo() {
    print('Nombre: ${nameController.text}');
    print('Apellido: ${lastNameController.text}');
    print('Correo: ${emailController.text}');
  }

  void changePassword() {
    print('Cambiar contraseña presionado');
  }
}
