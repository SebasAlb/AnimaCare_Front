import 'package:flutter/material.dart';

class EventoCard extends StatelessWidget {
  const EventoCard({
    super.key,
    required this.tipo,
    required this.hora,
    required this.titulo,
    required this.mascota,
  });

  final String tipo;
  final String hora;
  final String titulo;
  final String mascota;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      color: tipo == 'evento'
          ? colorScheme.tertiaryContainer
          : colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Text(
          hora,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          titulo,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),

        trailing: SizedBox(
          width: 50, // puedes ajustar este valor según el diseño
          child: Text(
            mascota,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withOpacity(0.9),
            ),
          ),
        ),
      ),
    );
  }
}
