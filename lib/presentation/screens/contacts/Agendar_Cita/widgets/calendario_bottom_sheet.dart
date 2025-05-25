import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioBottomSheet extends StatefulWidget {
  final DateTime? fechaSeleccionada;
  final void Function(DateTime) onFechaSeleccionada;
  final bool Function(DateTime)? esNoLaboral;
  final String? Function(DateTime)? obtenerMotivoExcepcion;


  const CalendarioBottomSheet({
    super.key,
    required this.fechaSeleccionada,
    required this.onFechaSeleccionada,
    this.esNoLaboral,
    this.obtenerMotivoExcepcion,
  });

  @override
  State<CalendarioBottomSheet> createState() => _CalendarioBottomSheetState();
}

class _CalendarioBottomSheetState extends State<CalendarioBottomSheet> {
  String? mensajeInvalido;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TableCalendar(
            firstDay: now.subtract(const Duration(days: 30)),
            lastDay: now.add(const Duration(days: 90)),
            focusedDay: widget.fechaSeleccionada ?? now,
            selectedDayPredicate: (day) => isSameDay(widget.fechaSeleccionada, day),
            
            onDaySelected: (selectedDay, _) {
              final soloHoy = DateTime(now.year, now.month, now.day);
              final soloFecha = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

              final bool isPast = soloFecha.isBefore(soloHoy);
              final bool isNoLaboral = widget.esNoLaboral?.call(soloFecha) ?? false;
              final String? motivoExcepcion = widget.obtenerMotivoExcepcion?.call(soloFecha);

              if (isPast) {
                setState(() => mensajeInvalido = 'No se puede seleccionar una fecha pasada.');
                return;
              }

              if (motivoExcepcion != null) {
                setState(() => mensajeInvalido = 'No disponible: $motivoExcepcion');
                return;
              }

              if (isNoLaboral) {
                setState(() => mensajeInvalido = 'Ese día no es laboral para este veterinario.');
                return;
              }

              widget.onFechaSeleccionada(soloFecha);
              Navigator.pop(context);
            },
            calendarStyle: CalendarStyle(
              defaultDecoration: BoxDecoration(color: Colors.green.shade50),
              weekendDecoration: BoxDecoration(color: Colors.green.shade50),
              disabledDecoration: BoxDecoration(color: Colors.grey.shade200),
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final soloFecha = DateTime(day.year, day.month, day.day);
                final soloHoy = DateTime(now.year, now.month, now.day);
                final bool isPast = soloFecha.isBefore(soloHoy);
                final bool isNoLaboral = widget.esNoLaboral?.call(soloFecha) ?? false;
                final bool isExcepcion = widget.obtenerMotivoExcepcion?.call(soloFecha) != null;

                if (isExcepcion || isNoLaboral) {
                  Color overlayColor = isExcepcion
                      ? Colors.red.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3);

                  return Container(
                    decoration: BoxDecoration(
                      color: overlayColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(6),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }

                if (isPast) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(6),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return null;
              },
            ),
          ),
          if (mensajeInvalido != null) ...[
            const SizedBox(height: 12),
            Text(
              mensajeInvalido!,
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
          ]
        ],
      ),
    );
  }
}
