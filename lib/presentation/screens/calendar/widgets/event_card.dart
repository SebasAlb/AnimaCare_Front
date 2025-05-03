import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación corregida
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.nombre,
    required this.hora,
    required this.lugar,
    required this.veterinario,
    required this.color,
    required this.icono,
    required this.onTap,
    required this.mascota,
  });
  final String nombre;
  final String hora;
  final String lugar;
  final String veterinario;
  final String mascota;
  final Color color;
  final IconData icono;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        color: color,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          onTap: onTap,
          title: Row(
            children: <Widget>[
              // Hora (20%)
              Expanded(
                flex: 3,
                child: Text(
                  hora,
                  style: TextStyle(
                    color: AppColors.primaryWhite.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),

              // Nombre del evento (40%)
              Expanded(
                flex: 4,
                child: Align(
                  child: Text(
                    nombre,
                    textAlign: TextAlign
                        .center, // << Además, centra el texto dentro del espacio del Text
                    style: const TextStyle(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false, // << No permite que baje a otra línea
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Nombre de la mascota (40%) + icono
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Icon(Icons.pets,
                        color: AppColors.primaryWhite, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      mascota,
                      style: const TextStyle(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
