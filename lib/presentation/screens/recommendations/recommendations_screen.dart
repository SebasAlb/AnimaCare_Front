import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'recommendations_controller.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecommendationsController());

    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      body: SafeArea(
        child: Column(
          children: [
            // Header fuera del padding para ocupar todo el ancho
            Obx(() => CustomHeader(
              petName: controller.petName.value,
              onEdit: () {},
              onViewRecord: () {},
            )),
            const SizedBox(height: 20),
            // El resto del contenido con padding interno
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Datos de la mascota
                    Column(
                      children: [
                        // Tipo de Mascota ocupa toda la fila
                        _buildDataTile('Tipo de Mascota', controller.petType.value),
                        const SizedBox(height: 10),
                        // Género, Raza en dos columnas
                        Row(
                          children: [
                            Expanded(child: _buildDataTile('Género', controller.petGender.value)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildDataTile('Raza', controller.petBreed.value)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Edad ocupa una sola columna
                        Row(
                          children: [
                            Expanded(child: _buildDataTile('Edad', controller.petAge.value)),
                            const SizedBox(width: 10),
                            const Expanded(child: SizedBox()), // Espacio vacío para balancear
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recomendaciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Listado de recomendaciones
                    Expanded(
                      child: Obx(() => ListView.builder(
                        itemCount: controller.recommendations.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: const Color(0xFF3E0B53),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                controller.recommendations[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          // Acción cuando cambies de tab
        },
      ),
    );
  }

  Widget _buildDataTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(minHeight: 50), // Alto mínimo
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
