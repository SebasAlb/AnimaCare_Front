import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación corregida

class CalendarDayItem extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isOverloaded;

  const CalendarDayItem({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.isOverloaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (isSelected) {
      backgroundColor =
          isOverloaded ? AppColors.markerBorder : AppColors.selectedDay;
      textColor = AppColors.primaryWhite;
    } else if (isOverloaded) {
      backgroundColor = AppColors.transparent;
      textColor = Colors.black;
    } else {
      backgroundColor = AppColors.transparent;
      textColor = Colors.black;
    }

    return Container(
      margin: const EdgeInsets.all(6.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: isOverloaded && !isSelected
            ? Border.all(color: AppColors.markerBorder, width: 2)
            : null,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
