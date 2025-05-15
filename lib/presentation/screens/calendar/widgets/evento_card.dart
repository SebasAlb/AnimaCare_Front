import 'package:flutter/material.dart';

class EventoCard extends StatelessWidget {
  const EventoCard({
    super.key,
    required this.hora,
    required this.titulo,
    required this.mascota,
  });

  final String hora;
  final String titulo;
  final String mascota;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Text(
          hora,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        title: Text(
          titulo,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Text(
          mascota,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
