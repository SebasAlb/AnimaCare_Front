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
  final Map<DateTime, List<EventoCalendar>> eventosMarcados;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        // Calendario visual
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.cardColor,
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
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(color: Colors.white),
              selectedTextStyle: const TextStyle(color: Colors.white),
              markerDecoration: BoxDecoration(
                color: theme.primaryColorDark,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: theme.textTheme.bodyMedium!,
              weekendTextStyle: theme.textTheme.bodyMedium!,
              outsideTextStyle: theme.textTheme.bodyMedium!.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Eventos para el día',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
}
