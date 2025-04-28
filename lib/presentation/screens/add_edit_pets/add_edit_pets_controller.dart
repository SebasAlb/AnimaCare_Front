// File: controllers/add_edit_pet_controller.dart
import 'package:flutter/material.dart';

class AddEditPetController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedPetType = '';
  String selectedGender = '';

  void setPetType(String value) {
    selectedPetType = value;
    notifyListeners();
  }

  void setGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void registerPet() {
    // Aquí pondrías la lógica para guardar la mascota (API, BD, etc.)
    print('Mascota registrada:');
    print('Nombre: ${nameController.text}');
    print('Tipo: $selectedPetType');
    print('Género: $selectedGender');
    print('Raza: ${breedController.text}');
    print('Edad: ${ageController.text}');
  }
}
