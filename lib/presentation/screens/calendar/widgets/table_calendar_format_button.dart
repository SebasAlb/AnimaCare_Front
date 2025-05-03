import 'package:animacare_front/presentation/screens/calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarFormatButton extends StatelessWidget {
  const TableCalendarFormatButton({super.key, required this.controller});
  final CalendarController controller;

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
  Widget build(BuildContext context) => Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3E0B53),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _toggleFormat,
          child: Text(_getFormatName(controller.calendarFormat.value)),
        ),
      );
}
