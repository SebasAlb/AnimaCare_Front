import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../calendar_controller.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación correcta

class MonthPickerSheet extends StatelessWidget {
  final CalendarController controller;

  const MonthPickerSheet({Key? key, required this.controller})
      : super(key: key);

  String _monthName(int month) {
    const months = [
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
      'Diciembre'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return ElevatedButton(
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
        );
      },
    );
  }
}

class YearPickerSheet extends StatelessWidget {
  final CalendarController controller;

  const YearPickerSheet({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 11,
      itemBuilder: (context, index) {
        final year = 2020 + index;
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
}
