import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNotificationsController extends GetxController {
  final RxString anticipacion = '1 día antes'.obs;
  final RxString frecuencia = 'Cada 6 horas'.obs;
  final RxString recibirRecomendaciones = 'Solo en la app'.obs;

  final Rx<Color> colorCalendario = const Color(0xFFFFFFFF).obs;
  final Rx<Color> colorDiasCargados = const Color(0xFFFFA726).obs;

  final RxMap<String, Map<String, dynamic>> categorias = <String, Map<String, dynamic>>{
    'Baño': <String, >{'color': Colors.blue, 'icon': Icons.shower},
    'Veterinario': <String, >{'color': Colors.green, 'icon': Icons.local_hospital},
    'Medicina': <String, >{
      'color': Colors.yellow.shade700,
      'icon': Icons.medical_services,
    },
    'Vacuna': <String, >{'color': Colors.lightBlueAccent, 'icon': Icons.vaccines},
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
      final Map<String, dynamic>? datos = categorias.remove(viejoNombre);
      categorias[nuevoNombre] = datos!;
      categorias.refresh();
    }
  }

  void eliminarCategoria(String categoria) {
    categorias.remove(categoria);
    categorias.refresh();
  }

  void agregarCategoria(String nombre, Color color, IconData icono) {
    categorias[nombre] = <String, >{'color': color, 'icon': icono};
    categorias.refresh();
  }
}
