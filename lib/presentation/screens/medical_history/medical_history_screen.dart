import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/custom_header.dart';
import '../../../components/custom_navbar.dart';
import '../../../../routes/app_routes.dart';
import 'medical_history_controller.dart'; // Creamos el controlador también

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicalHistoryController());

    return Scaffold(
      backgroundColor: const Color(0xFF4DD0E2),
      body: SafeArea(
        child: Column(
          children: [
            // Header fuera del padding para ocupar todo el ancho
            CustomHeader(
              petName: controller.petName.value,
              onEdit: () {
                Navigator.pushNamed(context, AppRoutes.editMedicalHistory);
              },
              onViewRecord: () {
                Navigator.pushNamed(context, AppRoutes.viewMedicalRecord);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Historial Médico',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Información médica
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Obx(() => ListView(
                          children: [
                            _buildEditableDataTile(
                              label: 'Vacunas',
                              value: controller.vaccines.value,
                              onEdit: controller.updateVaccines,
                            ),
                            const SizedBox(height: 10),
                            _buildEditableDataTile(
                              label: 'Desparasitaciones',
                              value: controller.dewormings.value,
                              onEdit: controller.updateDewormings,
                            ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.calendar);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.map);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }

  Widget _buildEditableDataTile({required String label, required String value, required Function(String) onEdit}) {
    return GestureDetector(
      onTap: () => _showEditDialog(label, value, onEdit),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(minHeight: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);

    Get.dialog(
      AlertDialog(
        title: Text('Editar $title'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ingrese nuevo valor'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Get.back();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

import 'package:get/get.dart';

class MedicalHistoryController extends GetxController {
  var petName = 'Nombre Mascota'.obs;
  var vaccines = 'Vacuna de la rabia aplicada.'.obs;
  var dewormings = 'Última desparasitación hace 3 meses.'.obs;

  void updateVaccines(String newValue) {
    vaccines.value = newValue;
  }

  void updateDewormings(String newValue) {
    dewormings.value = newValue;
  }
}
