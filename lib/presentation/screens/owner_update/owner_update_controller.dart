import 'package:flutter/material.dart';

class OwnerUpdateController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
  }

  void saveUserInfo() {
    // Aquí haces lógica para guardar (por ahora, solo imprimir)
    print('Nombre: ${nameController.text}');
    print('Apellido: ${lastNameController.text}');
    print('Correo: ${emailController.text}');
  }

  void changePassword() {
    // Aquí podrías navegar a una nueva pantalla de "Cambiar contraseña"
    print('Cambiar contraseña presionado');
  }
}
