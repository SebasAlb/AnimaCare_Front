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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.primaryContainer, // Fondo adaptado a tema
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Text(
          hora,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer, // Contraste del texto
          ),
        ),
        title: Text(
          titulo,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        trailing: Text(
          mascota,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onPrimaryContainer.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}
