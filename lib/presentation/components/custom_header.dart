import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomHeader extends StatelessWidget {
  final String petName;
  final VoidCallback onEdit;
  final VoidCallback onViewRecord;

  const CustomHeader({
    super.key,
    required this.petName,
    required this.onEdit,
    required this.onViewRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF75C9C8),
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
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.vaccines, color: Colors.white),
                onPressed: onViewRecord,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
