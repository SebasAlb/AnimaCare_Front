import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación corregida

class EventCard extends StatelessWidget {
  final String nombre;
  final String hora;
  final String lugar;
  final String veterinario;
  final Color color;
  final IconData icono;
  final VoidCallback onTap;
  final String mascota;

  const EventCard({
    Key? key,
    required this.nombre,
    required this.hora,
    required this.lugar,
    required this.veterinario,
    required this.color,
    required this.icono,
    required this.onTap,
    required this.mascota,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                nombre,
                style: const TextStyle(
                  color: AppColors.primaryWhite, // <<< cambio aquí
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              hora,
              style: TextStyle(
                color: AppColors.primaryWhite.withOpacity(0.7), // <<< cambio aquí usando withOpacity
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icono, color: AppColors.primaryWhite), // <<< cambio aquí
          ],
        ),
      ),
    );
  }
}