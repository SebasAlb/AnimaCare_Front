import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomHeader extends StatelessWidget {
  final String petName;
  final VoidCallback onEdit;
  final VoidCallback onViewRecord;
  final bool isCalendarMode; // <<<<<< AÑADIDO PARA EL CALENDARIO

  const CustomHeader({
    super.key,
    required this.petName,
    required this.onEdit,
    required this.onViewRecord,
    this.isCalendarMode = false, // <<<<<< Valor por defecto, en el calendario se tienen dos opciones diferentes
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF35919E),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20),
              const SizedBox(width: 10),
              Text(
                petName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isCalendarMode ? Icons.add : Icons.edit, // <<<<<< Cambio dinámico
                  color: Colors.white,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(
                  isCalendarMode ? Icons.settings : Icons.vaccines, // <<<<<< Cambio dinámico
                  color: Colors.white,
                ),
                onPressed: onViewRecord,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
