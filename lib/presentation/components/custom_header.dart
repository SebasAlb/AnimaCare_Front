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
    {'hora': '09:00 AM', 'descripcion': 'Cita médica para Luna', 'veterinario': 'Dr. Pérez'},
    {'hora': '10:45 AM', 'descripcion': 'Vacuna antirrábica para Max', 'veterinario': 'Dra. López'},
    {'hora': '03:15 PM', 'descripcion': 'Desparasitación programada para Coco', 'veterinario': 'Dr. Gómez'},
    {'hora': '05:00 PM', 'descripcion': 'Control postoperatorio para Rocky', 'veterinario': 'Dra. Herrera'},
  ];

  void _mostrarNotificaciones(BuildContext context) {
    setState(() => notificacionesRevisadas = true);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notificaciones',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (final notif in notificaciones)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _notificacionCard(notif, theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificacionCard(Map<String, String> notif, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: theme.colorScheme.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notif['descripcion']!,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(notif['hora']!, style: theme.textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Text(notif['veterinario']!, style: theme.textTheme.bodySmall),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color background = theme.primaryColor;
    final Color textColor = Colors.white;

    if (widget.isSecondaryScreen) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: background,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.nameScreen,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            const SizedBox(width: 48), // Espacio para balancear diseño
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20),
              const SizedBox(width: 10),
              Text(widget.petName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: textColor)),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: textColor),
                onPressed: () => _mostrarNotificaciones(context),
              ),
              if (!notificacionesRevisadas)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.secondary,
                    ),
                    child: Text(
                      '${notificaciones.length}',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
