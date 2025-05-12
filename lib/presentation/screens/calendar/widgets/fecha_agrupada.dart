import 'package:flutter/material.dart';

class FechaAgrupada extends StatelessWidget {

  const FechaAgrupada({super.key, required this.fecha});
  final String fecha;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        fecha,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF14746F), // verde marino
        ),
      ),
    );
}
