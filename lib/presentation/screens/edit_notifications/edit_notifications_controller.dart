import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditNotificationsController extends GetxController {
  final anticipacion = '1 día antes'.obs;
  final frecuencia = 'Cada 6 horas'.obs;
  final recibirRecomendaciones = 'Solo en la app'.obs;

  final colorCalendario = const Color(0xFFFFFFFF).obs;
  final colorDiasCargados = const Color(0xFFFFA726).obs; // naranja pastel

  final coloresCategorias = {
    'Baño': Colors.blue,
    'Veterinario': Colors.green,
    'Medicina': Colors.yellow.shade700,
    'Vacuna': Colors.lightBlueAccent,
  }.obs;

  void actualizarColorCategoria(String categoria, Color nuevoColor) {
    coloresCategorias[categoria] = nuevoColor;
  }
}