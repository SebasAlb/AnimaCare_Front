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
  Widget build(BuildContext context) => Card(
      color: const Color(0xFF1BB0A2), // verde claro de acento
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Text(
          hora,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        title: Text(titulo, style: const TextStyle(color: Colors.white)),
        trailing: Text(mascota, style: const TextStyle(color: Colors.white)),
      ),
    );
}

