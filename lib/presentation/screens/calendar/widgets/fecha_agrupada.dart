import 'package:flutter/material.dart';

class FechaAgrupada extends StatelessWidget {
  const FechaAgrupada({
    super.key,
    required this.fecha,
    this.onTap,
  });

  final String fecha;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          fecha,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
