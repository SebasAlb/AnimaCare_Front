import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/screens/home/Mascota_Principal/home_controller.dart';
import 'package:animacare_front/presentation/screens/home/Mascota_Principal/widgets/pet_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = HomeController();

    return Scaffold(
      backgroundColor: const Color(0xFF7B4A91),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CustomHeader(
              petName: 'Sebastián',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                '🐾 Mascotas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFFE066),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children:
                      controller.mascotas.map((m) => PetCard(name: m)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.onAgregarMascota(context),
        backgroundColor: const Color(0xFFFFE066),
        icon: const Icon(Icons.add, color: Color(0xFF4B1B3F)),
        label: const Text(
          'Agregar mascota',
          style: TextStyle(
            color: Color(0xFF4B1B3F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.contactsP);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.calendar);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.settingsP);
              break;
          }
        },
      ),
    );
  }
}
