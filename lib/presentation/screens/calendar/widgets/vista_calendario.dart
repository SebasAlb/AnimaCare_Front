import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_card.dart';

class VistaCalendario extends StatelessWidget {

  const VistaCalendario({
    super.key,
    required this.eventos,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.onTapEvento,
  });
  final List<Map<String, dynamic>> eventos;
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(Map<String, dynamic>) onTapEvento;

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
          child: TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2020),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (DateTime day) => isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
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
              final Map<String, dynamic> e = eventos[index];
              return GestureDetector(
                onTap: () => onTapEvento(e),
                child: EventoCard(
                  hora: e['hora'],
                  titulo: e['titulo'],
                  mascota: e['mascota'],
                ),
              );
            },
          ),
        ),
      ],
    );
}
