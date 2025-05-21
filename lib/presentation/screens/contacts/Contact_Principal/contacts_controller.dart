import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contacto_Detalle/contact_info_screen.dart';
import 'package:flutter/material.dart';

class ContactsController {
  final List<Map<String, String>> contactos = <Map<String, String>>[
    <String, String>{'nombre': 'Dra. Lazo', 'estado': 'Disponible'},
    <String, String>{'nombre': 'Dr. Mario Paz', 'estado': 'Vacaciones'},
    <String, String>{'nombre': 'Dra. Lucía Andrade', 'estado': 'No disponible'},
    <String, String>{'nombre': 'Dr. Esteban Ortega', 'estado': 'Disponible'},
  ];

  void abrirDetalle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContactInfoScreen()),
    );
  }

  void abrirAgendarCita(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AgendarCitaScreen()),
    );
  }
}
