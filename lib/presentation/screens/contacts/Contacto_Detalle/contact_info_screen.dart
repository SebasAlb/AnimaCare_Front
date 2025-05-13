import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contacto_Detalle/contact_info_controller.dart';

class ContactInfoScreen extends StatelessWidget {
  const ContactInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactInfoController controller = ContactInfoController();

    return Scaffold(
      backgroundColor: const Color(0xFF7B4A91),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomHeader(
              nameScreen: "Contactos",
              isSecondaryScreen: true,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF4B1B3F), width: 8),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Veterinario',
                          style: TextStyle(
                            color: Color(0xFFFFE066),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                      const SizedBox(height: 25),
                      Column(
                        children: <Widget>[
                          _infoLinea(Icons.phone, controller.telefono),
                          const SizedBox(height: 8),
                          _infoLinea(Icons.email, controller.correo),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Información adicional',
                          style: TextStyle(
                            color: Color(0xFFFFE066),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...controller.infoExtra.map(
                        (item) =>
                            InfoItem(icon: item['icon'], text: item['text']),
                      ),
                      const SizedBox(height: 25),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Horario de atención',
                          style: TextStyle(
                            color: Color(0xFFFFE066),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B1B3F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: HorarioTable(horarios: controller.horarios),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 16),
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFFFFE066),
            foregroundColor: const Color(0xFF4B1B3F),
            icon: const Icon(Icons.event_available),
            label: const Text('Agendar Cita'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AgendarCitaScreen(),),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoLinea(IconData icon, String text) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: const Color(0xFFFFE066), size: 20),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFFFE066),
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
}

class InfoItem extends StatelessWidget {

  const InfoItem({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
}

class HorarioTable extends StatelessWidget {

  const HorarioTable({super.key, required this.horarios});
  final Map<String, String> horarios;

  @override
  Widget build(BuildContext context) => Column(
      children: horarios.entries.map((MapEntry<String, String> entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                entry.key,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                entry.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),).toList(),
    );
}
