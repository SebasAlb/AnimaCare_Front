import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/presentation/screens/recommendations/recommendations_controller.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RecommendationsController controller = Get.put(RecommendationsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomHeader(
              petName: 'Gato 1',
              onEdit: () {
                Navigator.pushNamed(context, AppRoutes.addEditPet);
              },
              onViewRecord: () {
                Navigator.pushNamed(context, AppRoutes.medicalhistory);
              },
              isRecommendationMode: true,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    // Datos de la mascota
                    Column(
                      children: <Widget>[
                        // Tipo de Mascota ocupa toda la fila
                        _buildDataTile(
                            'Tipo de Mascota', controller.petType.value,),
                        const SizedBox(height: 10),
                        // Género, Raza en dos columnas
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: _buildDataTile(
                                    'Género', controller.petGender.value,),),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _buildDataTile(
                                    'Raza', controller.petBreed.value,),),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Edad ocupa una sola columna
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: _buildDataTile(
                                    'Edad', controller.petAge.value,),),
                            const SizedBox(width: 10),
                            const Expanded(
                                child:
                                    SizedBox(),), // Espacio vacío para balancear
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
                            itemBuilder: (context, index) => Card(
                                color: const Color(0xFF301B92),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    controller.recommendations[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ),),
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

  Widget _buildDataTile(String label, String value) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(minHeight: 50), // Alto mínimo
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
}
