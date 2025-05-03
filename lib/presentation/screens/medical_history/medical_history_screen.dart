import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/presentation/screens/medical_history/medical_history_controller.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicalHistoryController controller =
        Get.put(MedicalHistoryController());

    return Scaffold(
      backgroundColor: const Color(0xFF4DD0E2),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomHeader(
              petName: 'Gato 1',
              onEdit: () {
                Navigator.pushNamed(context, AppRoutes.ownerUpdate);
              },
              onViewRecord: () {
                Navigator.pushNamed(context, AppRoutes.ownerUpdate);
              },
              isHistoryMode: true,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
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
                        child: Obx(
                          () => ListView(
                            children: <Widget>[
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
                          ),
                        ),
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
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.calendar);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.ownerUpdate);
              break;
          }
        },
      ),
    );
  }

  Widget _buildEditableDataTile({
    required String label,
    required String value,
    required Function(String) onEdit,
  }) =>
      GestureDetector(
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
            children: <Widget>[
              Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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

  void _showEditDialog(
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    Get.dialog(
      AlertDialog(
        title: Text('Editar $title'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ingrese nuevo valor'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: Get.back,
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
