import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_card.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/fecha_agrupada.dart';

class VistaEventos extends StatelessWidget {

  const VistaEventos({
    super.key,
    required this.eventos,
    required this.controller,
    required this.onTapEvento,
  });
  final List<Map<String, dynamic>> eventos;
  final TextEditingController controller;
  final Function(Map<String, dynamic>) onTapEvento;

  @override
  Widget build(BuildContext context) => Column(
      children: <Widget>[
        // Barra de búsqueda
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Buscar eventos...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // Lista de eventos agrupados (esto puede cambiar si luego agrupas por fecha real)
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: <Widget>[
              if (eventos.isNotEmpty)
                const FechaAgrupada(fecha: 'Eventos encontrados')
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('No se encontraron eventos.'),
                  ),
                ),
              ...eventos.map((Map<String, dynamic> e) => GestureDetector(
                    onTap: () => onTapEvento(e),
                    child: EventoCard(
                      hora: e['hora'],
                      titulo: e['titulo'],
                      mascota: e['mascota'],
                    ),
                  ),),
            ],
          ),
        ),
      ],
    );
}
