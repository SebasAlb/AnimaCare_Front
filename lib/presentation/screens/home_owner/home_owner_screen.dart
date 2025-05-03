import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_owner_controller.dart';
import 'package:animacare_front/presentation/components/exit_dialog.dart';

class HomeOwnerScreen extends StatelessWidget {
  const HomeOwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeOwnerController());

    return WillPopScope(
      onWillPop: () async {
        return await ExitDialog.show();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF4DD0E2),
        body: SafeArea(
          child: Column(
            children: [
              CustomHeader(
                petName: 'Sebastian',
                onEdit: () {
                  Navigator.pushNamed(context, AppRoutes.ownerUpdate);
                },
                onViewRecord: () {
                  Navigator.pushNamed(context, AppRoutes.editNotifications);
                },
                isOwnerMode: true,
              ),
              const SizedBox(height: 20),

              // Botón de agregar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción al presionar el botón
                      Navigator.pushNamed(context, AppRoutes.addEditPet);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                      backgroundColor: Colors.white, // Fondo blanco
                      foregroundColor: Colors.deepPurple, // Icono color morado
                      elevation: 5,
                    ),
                    child: const Icon(Icons.add, size: 28),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Obx(() => ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.pets.length,
                      itemBuilder: (context, index) {
                        final pet = controller.pets[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildPetCard(
                              context, pet['name']!, pet['description']!),
                        );
                      },
                    )),
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
                break;
              case 2:
                Navigator.pushNamed(context, AppRoutes.ownerUpdate);
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, String name, String description) {
    final controller = Get.put(HomeOwnerController());
    return InkWell(
      onTap: () {
        controller.goToDetailsPet();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.pets, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
