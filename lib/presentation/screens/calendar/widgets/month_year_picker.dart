import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/presentation/screens/calendar/calendar_controller.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación correcta

class MonthPickerSheet extends StatelessWidget {

  const MonthPickerSheet({super.key, required this.controller});
  final CalendarController controller;

  String _monthName(int month) {
    const List<String> months = <String>[
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) => GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.formatButtonBackground,
            foregroundColor: AppColors.formatButtonForeground,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            controller.cambiarMes(index + 1);
            Navigator.pop(context);
          },
          child: Text(_monthName(index + 1)),
        ),
    );
}

class YearPickerSheet extends StatelessWidget {

  const YearPickerSheet({super.key, required this.controller});
  final CalendarController controller;

  @override
  Widget build(BuildContext context) => ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 11,
      itemBuilder: (BuildContext context, int index) {
        final int year = 2020 + index;
        return ListTile(
          title: Text(
            '$year',
            style: const TextStyle(
              color: AppColors
                  .formatButtonForeground, // Coloreamos también los años
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            controller.cambiarAnio(year);
            Navigator.pop(context);
          },
        );
      },
    );
}
