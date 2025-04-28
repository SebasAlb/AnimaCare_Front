import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomHeader extends StatelessWidget {
  final String petName;
  final VoidCallback onEdit;
  final VoidCallback onViewRecord;
  final bool isCalendarMode;
  final bool isOwnerMode;
  final bool isRecommendationMode;


  const CustomHeader({
    super.key,
    required this.petName,
    required this.onEdit,
    required this.onViewRecord,
    this.isCalendarMode = false,
    this.isOwnerMode = false,
    this.isRecommendationMode = false,
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
                  _getEditIcon(),
                  color: Colors.white,
                ),
                onPressed: onEdit,
              ),
              if (!isOwnerMode) // Solo si el ícono existe
                IconButton(
                  icon: Icon(
                    _getSettingsIcon(),
                    color: Colors.white
                  ),
                  onPressed: onViewRecord,
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getEditIcon() {
    if (isRecommendationMode) return Icons.recommend;
    if (isCalendarMode && isOwnerMode) return Icons.add;
    return Icons.edit;
  }

  IconData _getSettingsIcon() {
    return isCalendarMode ? Icons.settings : Icons.vaccines;
  }

}

