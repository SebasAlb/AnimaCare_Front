import 'package:flutter/material.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({
    super.key,
    required this.petName,
  });

  final String petName;

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  bool notificacionesRevisadas = false;

  final List<Map<String, String>> notificaciones = <Map<String, String>>[
    <String, String>{
      'hora': '09:00 AM',
      'descripcion': 'Cita médica para Luna',
      'veterinario': 'Dr. Pérez',
    },
    <String, String>{
      'hora': '10:45 AM',
      'descripcion': 'Vacuna antirrábica para Max',
      'veterinario': 'Dra. López',
    },
    <String, String>{
      'hora': '03:15 PM',
      'descripcion': 'Desparasitación programada para Coco',
      'veterinario': 'Dr. Gómez',
    },
    <String, String>{
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
      builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Row(
                  children: <Widget>[
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
                for (final Map<String, String> notif in notificaciones)
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

  Widget _notificacionCard(Map<String, String> notif) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.notifications_active, color: Color(0xFF1BB0A2)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  children: <Widget>[
                    Text(
                      notif['hora']!,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      notif['veterinario']!,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: Color(0xFF35919E)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
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
            children: <Widget>[
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
