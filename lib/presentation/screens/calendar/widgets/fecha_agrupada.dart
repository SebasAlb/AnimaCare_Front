import 'package:flutter/material.dart';

class FechaAgrupada extends StatelessWidget {
  const FechaAgrupada({super.key, required this.fecha});
  final String fecha;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        fecha,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
