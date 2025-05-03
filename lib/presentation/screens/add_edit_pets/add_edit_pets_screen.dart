import 'package:animacare_front/presentation/screens/add_edit_pets/add_edit_pets_controller.dart';
import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditPetScreen extends StatelessWidget {
  const AddEditPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddEditPetController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<AddEditPetController>(
            builder: (context, controller, child) {
              return WillPopScope(
                onWillPop: () => _confirmarSalida(context, controller),
                child: Column(
                  children: [
                    _buildHeader(context, controller),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.cardBackground,
                              child: Icon(Icons.pets,
                                  size: 80, color: AppColors.header),
                            ),
                            const SizedBox(height: 24),
                            _buildTextField(
                              label: 'Nombre',
                              hint: 'Ingrese el nombre de la mascota',
                              controller: controller.nameController,
                              icon: Icons.pets,
                            ),
                            const SizedBox(height: 20),
                            _buildDropdown(
                              label: 'Tipo de Mascota',
                              value: controller.selectedPetType,
                              items: ['Perro', 'Gato', 'Ave', 'Otro'],
                              onChanged: controller.setPetType,
                            ),
                            const SizedBox(height: 20),
                            _buildDropdown(
                              label: 'Género',
                              value: controller.selectedGender,
                              items: ['Macho', 'Hembra'],
                              onChanged: controller.setGender,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Raza',
                              hint: 'Ingrese la raza',
                              controller: controller.breedController,
                              icon: Icons.pets_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Edad',
                              hint: 'Ingrese la edad',
                              controller: controller.ageController,
                              icon: Icons.cake,
                              type: TextInputType.number,
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.header,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: controller.registerPet,
                              child: const Text(
                                'Registrar Mascota',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AddEditPetController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: AppColors.header),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final salir = await _confirmarSalida(context, controller);
              if (salir) Navigator.pop(context);
            },
          ),
          const Text(
            'Agregar/Editar Mascota',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.header),
            filled: true,
            fillColor: const Color(0xFFF0F4F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value.isEmpty ? null : value,
            hint: const Text('Seleccionar'),
            isExpanded: true,
            underline: Container(),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  Future<bool> _confirmarSalida(
      BuildContext context, AddEditPetController controller) async {
    final hayCambios = controller.nameController.text.isNotEmpty ||
        controller.breedController.text.isNotEmpty ||
        controller.ageController.text.isNotEmpty ||
        controller.selectedPetType.isNotEmpty ||
        controller.selectedGender.isNotEmpty;

    if (hayCambios) {
      final salir = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¿Descartar cambios?'),
          content: const Text(
              'Tienes cambios sin guardar. ¿Seguro que quieres salir?'),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir'),
            ),
          ],
        ),
      );
      return salir ?? false;
    }

    return true;
  }
}
