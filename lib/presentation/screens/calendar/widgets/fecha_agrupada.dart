import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';

class FechaAgrupada extends StatelessWidget {
  const FechaAgrupada({
    super.key,
    required this.fecha,
    this.onTap,
    required this.eventMascota
  });

  final String fecha;
  final VoidCallback? onTap;
  final bool eventMascota;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (eventMascota == false) {
            SoundService.playButton();
          }
          if (onTap != null) {
            onTap!();
          }
        },
        child: Text(
          fecha,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            decoration: eventMascota == false ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
