import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/contacts/Contact_Principal/widget/contact_card.dart';
//import '../Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contact_Principal/contacts_controller.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactsController controller = ContactsController();

    return Scaffold(
      backgroundColor: const Color(0xFFD5F3F1),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomHeader(
              petName: 'Gato 1',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  'Contactos',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14746F),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.contactos.length,
                itemBuilder: (context, index) {
                  final Map<String, String> contacto = controller.contactos[index];
                  return ContactCard(
                    name: contacto['nombre']!,
                    estado: contacto['estado']!,
                    onTap: () => controller.abrirDetalle(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.abrirAgendarCita(context),
        backgroundColor: const Color(0xFFFFE066),
        icon: const Icon(Icons.event_available, color: Color(0xFF4B1B3F)),
        label: const Text(
          'Agendar Cita',
          style: TextStyle(
            color: Color(0xFF4B1B3F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 1:
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
