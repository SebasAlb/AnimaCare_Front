import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditNotificationsController extends GetxController {
  final anticipacion = '1 día antes'.obs;
  final frecuencia = 'Cada 6 horas'.obs;
  final recibirRecomendaciones = 'Solo en la app'.obs;

  final colorCalendario = const Color(0xFFFFFFFF).obs;
  final colorDiasCargados = const Color(0xFFFFA726).obs;

  final categorias = <String, Map<String, dynamic>>{
    'Baño': {'color': Colors.blue, 'icon': Icons.shower},
    'Veterinario': {'color': Colors.green, 'icon': Icons.local_hospital},
    'Medicina': {'color': Colors.yellow.shade700, 'icon': Icons.medical_services},
    'Vacuna': {'color': Colors.lightBlueAccent, 'icon': Icons.vaccines},
  }.obs;

  void actualizarColorCategoria(String categoria, Color nuevoColor) {
    if (categorias.containsKey(categoria)) {
      categorias[categoria]!['color'] = nuevoColor;
      categorias.refresh();
    }
  }

  void actualizarIconoCategoria(String categoria, IconData nuevoIcono) {
    if (categorias.containsKey(categoria)) {
      categorias[categoria]!['icon'] = nuevoIcono;
      categorias.refresh();
    }
  }

  void actualizarNombreCategoria(String viejoNombre, String nuevoNombre) {
    if (categorias.containsKey(viejoNombre)) {
      final datos = categorias.remove(viejoNombre);
      categorias[nuevoNombre] = datos!;
      categorias.refresh();
    }
  }

  void eliminarCategoria(String categoria) {
    categorias.remove(categoria);
    categorias.refresh();
  }

  void agregarCategoria(String nombre, Color color, IconData icono) {
    categorias[nombre] = {'color': color, 'icon': icono};
    categorias.refresh();
  }
}
