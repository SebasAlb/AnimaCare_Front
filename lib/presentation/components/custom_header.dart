import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({
    super.key,
    this.petName = '',
    this.nameScreen = '',
    this.isSecondaryScreen = false,
    this.onBack,
    this.onBackConfirm,
    this.mostrarMascota = false,
  });

  final String petName;
  final String nameScreen;
  final bool isSecondaryScreen;
  final VoidCallback? onBack;
  final Future<bool> Function()? onBackConfirm;
  final bool mostrarMascota;

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  late final Dueno? dueno;
  bool notificacionesRevisadas = false;

  @override
  void initState() {
    super.initState();
    dueno = UserStorage.getUser();
  }

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
    final ThemeData theme = Theme.of(context);

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

  Widget _notificacionCard(Map<String, String> notif, ThemeData theme) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Icon(Icons.notifications_active, color: theme.colorScheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif['descripcion']!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color textColor = Colors.white;
    final Color background = theme.primaryColor;

    if (widget.isSecondaryScreen) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: background,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: textColor),
              onPressed: () async {
                SoundService.playButton();
                if (widget.onBackConfirm != null) {
                  final canExit = await widget.onBackConfirm!();
                  if (canExit) {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.pop(context);
                    }
                  }
                } else {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.nameScreen,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );
    }

    final String avatarUrl = dueno?.fotoUrl ?? '';
    final String displayName = widget.mostrarMascota
        ? widget.petName
        : '${dueno?.nombre ?? ''} ${dueno?.apellido ?? ''}'.trim().isEmpty
        ? 'Usuario'
        : '${dueno!.nombre} ${dueno!.apellido}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white24,
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                child: avatarUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 24)
                    : null,
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180), // ajusta si necesitas más o menos
                child: Text(
                  displayName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: textColor),
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
