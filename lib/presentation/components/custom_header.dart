import 'package:flutter/material.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({
    super.key,
    this.petName = '',
    this.nameScreen = '',
    this.isSecondaryScreen = false,
    this.onBack,
  });

  final String petName;
  final String nameScreen;
  final bool isSecondaryScreen;
  final VoidCallback? onBack;

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  bool notificacionesRevisadas = false;

  final List<Map<String, String>> notificaciones = [
    {
      'hora': '09:00 AM',
      'descripcion': 'Cita médica para Luna',
      'veterinario': 'Dr. Pérez',
    },
    {
      'hora': '10:45 AM',
      'descripcion': 'Vacuna antirrábica para Max',
      'veterinario': 'Dra. López',
    },
    {
      'hora': '03:15 PM',
      'descripcion': 'Desparasitación programada para Coco',
      'veterinario': 'Dr. Gómez',
    },
    {
      'hora': '05:00 PM',
      'descripcion': 'Control postoperatorio para Rocky',
      'veterinario': 'Dra. Herrera',
    },
  ];

  void _mostrarNotificaciones(BuildContext context) {
    setState(() => notificacionesRevisadas = true);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFD5F3F1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notificaciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14746F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (final notif in notificaciones)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _notificacionCard(notif),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificacionCard(Map<String, String> notif) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Color(0xFF1BB0A2)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['descripcion']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      notif['hora']!,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      notif['veterinario']!,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSecondaryScreen) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: const Color(0xFF35919E),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.nameScreen,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 48), // Espacio para balancear diseño
          ],
        ),
      );
    }

    // Header normal
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Color(0xFF35919E)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20),
              const SizedBox(width: 10),
              Text(
                widget.petName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () => _mostrarNotificaciones(context),
              ),
              if (!notificacionesRevisadas)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1BB0A2),
                    ),
                    child: Text(
                      '${notificaciones.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
