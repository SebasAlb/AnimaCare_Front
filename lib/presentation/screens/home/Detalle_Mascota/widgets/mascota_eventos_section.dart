import 'package:flutter/material.dart';

class MascotaEventosSection extends StatelessWidget {
  const MascotaEventosSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Eventos de la mascota',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Aquí se mostrarán los eventos relacionados con la mascota.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
