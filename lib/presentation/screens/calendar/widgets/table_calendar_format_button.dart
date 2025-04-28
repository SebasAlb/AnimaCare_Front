import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación correcta

class TableCalendarFormatButton extends StatelessWidget {
  final CalendarController controller;

  const TableCalendarFormatButton({Key? key, required this.controller}) : super(key: key);

  String _getFormatName(CalendarFormat format) {
    switch (format) {
      case CalendarFormat.month:
        return 'Mes';
      case CalendarFormat.twoWeeks:
        return '2 Semanas';
      case CalendarFormat.week:
        return '1 Semana';
      default:
        return '';
    }
  }

  void _toggleFormat() {
    if (controller.calendarFormat.value == CalendarFormat.month) {
      controller.calendarFormat.value = CalendarFormat.twoWeeks;
    } else if (controller.calendarFormat.value == CalendarFormat.twoWeeks) {
      controller.calendarFormat.value = CalendarFormat.week;
    } else {
      controller.calendarFormat.value = CalendarFormat.month;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3E0B53),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _toggleFormat,
          child: Text(_getFormatName(controller.calendarFormat.value)),
        ));
  }
}