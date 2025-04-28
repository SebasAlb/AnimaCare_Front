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
                petName: 'Dueño ...',
                onEdit: () {
                  Navigator.pushNamed(context, AppRoutes.ownerUpdate);
                },
                onViewRecord: () {
                  Navigator.pushNamed(context, AppRoutes.editNotifications);
                },
                isOwnerMode: true,
              ),
              const SizedBox(height: 20),
              // El resto del contenido con padding interno
              Expanded(
                child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.pets.length,
                  itemBuilder: (context, index) {
                    final pet = controller.pets[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPetCard(pet['name']!, pet['description']!),
                    );
                  },
                )),
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
                break;
              case 3:
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildPetCard(String name, String description) {
    return Container(
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
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.cyan[300],
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.pets, size: 30),
          Icon(Icons.lock, size: 30),
        ],
      ),
    );
  }
}
