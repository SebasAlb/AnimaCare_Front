// File: presentation/screens/add_edit_pet/add_edit_pet_screen.dart
import 'package:animacare_front/presentation/screens/add_edit_pets/add_edit_pets_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddEditPetScreen extends StatelessWidget {
  const AddEditPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddEditPetController(),
      child: Scaffold(
        backgroundColor: Color(0xFF4DD0E2),
        appBar: AppBar(
          backgroundColor: Color(0xFF301B92),
          title: const Text('Agregar/Editar', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AddEditPetController>(
            builder: (context, controller, child) => SingleChildScrollView(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.pets, size: 40, color: Color(0xFF4DD0E2)),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(controller.nameController, 'Nombre'),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    context,
                    'Tipo de Mascota',
                    controller.selectedPetType,
                    ['Perro', 'Gato', 'Ave', 'Otro'],
                    controller.setPetType,
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    context,
                    'Género',
                    controller.selectedGender,
                    ['Macho', 'Hembra'],
                    controller.setGender,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(controller.breedController, 'Raza'),
                  const SizedBox(height: 10),
                  _buildTextField(controller.ageController, 'Edad'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF301B92),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: controller.registerPet,
                    child: const Text(
                      'Registrar Nueva Mascota',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    String hint,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value.isEmpty ? null : value,
        hint: Text(hint),
        underline: Container(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
      ),
    );
  }
}
