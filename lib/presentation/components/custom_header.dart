import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {

  const CustomHeader({
    super.key,
    required this.petName,
    required this.onEdit,
    required this.onViewRecord,
    this.isCalendarMode = false,
    this.isOwnerMode = false,
    this.isRecommendationMode = false,
    this.isHistoryMode = false,
  });
  final String petName;
  final VoidCallback onEdit;
  final VoidCallback onViewRecord;
  final bool isCalendarMode;
  final bool isOwnerMode;
  final bool isRecommendationMode;
  final bool isHistoryMode;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF35919E),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
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
            children: <Widget>[
              if (!isOwnerMode && !isHistoryMode)
                IconButton(
                  icon: Icon(
                    _getEditIcon(),
                    color: Colors.white,
                  ),
                  onPressed: onEdit,
                ),
              if (!isOwnerMode && !isHistoryMode) // Solo si el ícono existe
                IconButton(
                  icon: Icon(_getSettingsIcon(), color: Colors.white),
                  onPressed: onViewRecord,
                ),
            ],
          ),
        ],
      ),
    );

  IconData _getEditIcon() {
    if (isRecommendationMode) return Icons.edit;
    if (isCalendarMode) return Icons.add;
    if (isOwnerMode) return Icons.edit;
    return Icons.edit;
  }

  IconData _getSettingsIcon() => isCalendarMode ? Icons.settings : Icons.medical_information;
}
