import 'package:flutter/material.dart';

class ContactInfoController {
  final String nombre = 'Dra. Lucía Andrade';
  final String telefono = '+593 987 654 321';
  final String correo = 'lucia@vetcare.ec';

  final List<Map<String, dynamic>> infoExtra = <Map<String, dynamic>>[
    <String, dynamic>{
      'icon': Icons.place,
      'text': 'Quito - Av. Siempreviva y Amazonas',
    },
    <String, dynamic>{
      'icon': Icons.pets,
      'text': 'Consulta general, vacunas y cirugía menor',
    },
    <String, dynamic>{
      'icon': Icons.school,
      'text': '10 años de experiencia profesional',
    },
  ];

  final Map<String, String> horarios = const <String, String>{
    'Lunes': '08:00 - 16:00',
    'Martes': '08:00 - 16:00',
    'Miércoles': '10:00 - 18:00',
    'Jueves': '08:00 - 16:00',
    'Viernes': '08:00 - 16:00',
    'Sábado': '09:00 - 13:00',
    'Domingo': 'Cerrado',
  };
}
