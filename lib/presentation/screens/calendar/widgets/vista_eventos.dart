import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_card.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/fecha_agrupada.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart'; // Modelo

class VistaEventos extends StatelessWidget {
  const VistaEventos({
    super.key,
    required this.eventos,
    required this.controller,
    required this.onTapEvento,
  });

  final List<EventoCalendar> eventos;
  final TextEditingController controller;
  final Function(EventoCalendar) onTapEvento;

  /// Agrupa los eventos por fecha (yyyy-MM-dd) y devuelve un Map ordenado
  Map<String, List<EventoCalendar>> agruparPorFecha(List<EventoCalendar> lista) {
    final Map<String, List<EventoCalendar>> agrupados = {};

    for (final evento in lista) {
      agrupados.putIfAbsent(evento.fecha, () => []).add(evento);
    }

    // Ordenar por fecha (opcional)
    final ordenado = Map.fromEntries(
      agrupados.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );

    return ordenado;
  }

  @override
  Widget build(BuildContext context) {
    final eventosAgrupados = agruparPorFecha(eventos);

    return Column(
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

        // Lista de eventos agrupados por fecha
        Expanded(
          child: eventos.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No se encontraron eventos.'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: eventosAgrupados.length,
                  itemBuilder: (context, index) {
                    final fecha = eventosAgrupados.keys.elementAt(index);
                    final eventosDelDia = eventosAgrupados[fecha]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FechaAgrupada(fecha: fecha),
                        ...eventosDelDia.map((evento) => GestureDetector(
                              onTap: () => onTapEvento(evento),
                              child: EventoCard(
                                hora: evento.hora,
                                titulo: evento.titulo,
                                mascota: evento.mascota,
                              ),
                            )),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

