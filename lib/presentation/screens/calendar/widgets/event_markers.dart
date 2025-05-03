import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación corregida

class EventMarkers extends StatelessWidget {

  const EventMarkers({
    super.key,
    required this.eventos,
  });
  final List<Map<String, String>> eventos;

  @override
  Widget build(BuildContext context) {
    if (eventos.isEmpty) return const SizedBox.shrink();

    final List<Widget> markers = eventos.take(4).map((evento) {
      final String nombre = (evento['nombre'] ?? '').toLowerCase();
      Color color;

      if (nombre.contains('baño')) {
        color = AppColors.eventBath;
      } else if (nombre.contains('veterinario') ||
          nombre.contains('consulta')) {
        color = AppColors.eventVetConsult;
      } else if (nombre.contains('medicina') ||
          nombre.contains('medicamento')) {
        color = AppColors.eventMedicine;
      } else if (nombre.contains('vacuna')) {
        color = AppColors.eventVaccine;
      } else {
        color = AppColors.eventOther;
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: markers,
    );
  }
}
