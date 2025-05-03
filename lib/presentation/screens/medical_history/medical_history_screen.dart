import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:animacare_front/presentation/screens/medical_history/medical_history_controller.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicalHistoryController controller = Get.put(MedicalHistoryController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomHeader(
              petName: controller.petName.value,
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
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView(
                          children: <Widget>[
                            _buildCategoryTile(
                              context,
                              label: 'Vacunas',
                              items: controller.vaccines,
                              color: AppColors.eventVaccine,
                            ),
                            const SizedBox(height: 10),
                            _buildCategoryTile(
                              context,
                              label: 'Desparasitaciones',
                              items: controller.dewormings,
                              color: AppColors.eventMedicine,
                            ),
                          ],
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

  Widget _buildCategoryTile(
    BuildContext context, {
    required String label,
    required List<String> items,
    required Color color,
  }) => GestureDetector(
      onTap: () => _showItemsDialog(context, label, items, color),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.header,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(minHeight: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryWhite,
                  fontSize: 16,),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primaryWhite),
          ],
        ),
      ),
    );

  void _showItemsDialog(
    BuildContext context,
    String title,
    List<String> items,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: Text(
            title,
            style: TextStyle(color: color),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                  leading:
                      const Icon(Icons.medical_services, color: Colors.grey),
                  title: Text(
                    items[index],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
    );
  }
}
