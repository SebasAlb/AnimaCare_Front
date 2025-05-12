import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_screen.dart';
import 'package:flutter/material.dart';

class HomeController {
  final List<String> mascotas = <String>[
    'Gato 1',
    'Gato 2',
    'Gato 3',
    'Perro 1',
  ];

  void onAgregarMascota(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AgregarMascotaScreen()),
    );
  }
}
