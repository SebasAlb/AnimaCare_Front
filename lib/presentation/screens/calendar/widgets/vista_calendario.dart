import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_card.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class VistaCalendario extends StatelessWidget {
  const VistaCalendario({
    super.key,
    required this.eventos,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onTapEvento,
    required this.eventosMarcados,
  });

  final List<EventoCalendar> eventos;
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(EventoCalendar) onTapEvento;

  /// Mapa de fechas con sus eventos para el calendario
  final Map<DateTime, List<EventoCalendar>> eventosMarcados;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          // Calendario visual
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TableCalendar<EventoCalendar>(
              focusedDay: focusedDay,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              onDaySelected: onDaySelected,
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return eventosMarcados[key] ?? [];
              },
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Color(0xFF14746F),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF1BB0A2),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF14746F),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Colors.white),
                selectedTextStyle: TextStyle(color: Colors.white),
                markerDecoration: BoxDecoration(
                  color: Color(0xFF4B1B3F),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Eventos para el día',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Lista de eventos del día
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: eventos.length,
              itemBuilder: (BuildContext context, int index) {
                final evento = eventos[index];
                return GestureDetector(
                  onTap: () => onTapEvento(evento),
                  child: EventoCard(
                    hora: evento.hora,
                    titulo: evento.titulo,
                    mascota: evento.mascota,
                  ),
                );
              },
            ),
          ),
        ],
      );
}

