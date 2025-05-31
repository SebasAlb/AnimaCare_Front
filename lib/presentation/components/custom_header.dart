import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';
import 'package:animacare_front/services/owner_service.dart';
import 'package:animacare_front/services/notification_service.dart';

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
  List<EventoCalendar> notificacionesHoy = [];
  final OwnerService _ownerService = OwnerService();

  @override
  void initState() {
    super.initState();
    print("-------------------- initi");
    dueno = UserStorage.getUser();
    _cargarNotificacionesHoy();

    // Solo para debug
    NotificationService.debugMostrarNotificacionesProgramadas();
  }

  Future<void> _cargarNotificacionesHoy() async {
    final duenoId = dueno?.id;
    if (duenoId == null) return;

    final mascotas = await _ownerService.obtenerCitasYEventos(duenoId);
    final hoy = DateTime.now();
    final hoyStr = _formatoFecha(hoy);

    final List<EventoCalendar> acumulado = [];

    for (final mascota in mascotas) {
      final eventosHoy = mascota.eventos
          .where((e) => _formatoFecha(e.fecha) == hoyStr)
          .map((e) => EventoCalendar(
        id: e.id.toString(),
        titulo: e.titulo,
        hora: _formatoHora(e.hora),
        fecha: _formatoFecha(e.fecha),
        mascota: mascota.nombreMascota,
        veterinario: '', // No hay veterinario en backend para eventos
        tipo: 'evento',
        categoria: null,
        estado: null,
        descripcion: e.descripcion,
      ));

      final citasHoy = mascota.citas
          .where((c) => _formatoFecha(c.fecha) == hoyStr)
          .map((c) => EventoCalendar(
        id: c.id.toString(),
        titulo: c.razon,
        hora: _formatoHora(c.hora),
        fecha: _formatoFecha(c.fecha),
        mascota: mascota.nombreMascota,
        veterinario: '', // No viene info del veterinario
        tipo: 'cita',
        categoria: null,
        estado: c.estado,
        descripcion: c.descripcion,
      ));

      final todosHoy = [...eventosHoy, ...citasHoy];
      acumulado.addAll(todosHoy);

      for (final ec in todosHoy) {
        final yaExiste = await NotificationService.existeNotificacion(ec.id);
        if (!yaExiste) {
          await NotificationService.programarNotificacion(ec);
        }
      }
    }

    acumulado.sort((a, b) => a.hora.compareTo(b.hora));
    setState(() => notificacionesHoy = acumulado);
  }

  void _mostrarNotificaciones(BuildContext context) {
    setState(() => notificacionesRevisadas = true);
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        initialChildSize: 0.5,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificaciones',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              if (notificacionesHoy.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('No tienes notificaciones para hoy', style: theme.textTheme.bodyMedium),
                ),
              for (final notif in notificacionesHoy)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _notificacionCard({
                    'titulo': notif.titulo,
                    'mascota': notif.mascota,
                    'hora': notif.hora,
                    'veterinario': notif.veterinario,
                    'descripcion': notif.descripcion ?? '',
                  }, theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatoFecha(DateTime fecha) =>
      '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';

  String _formatoHora(DateTime hora) =>
      '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';


  Widget _notificacionCard(Map<String, String> notif, ThemeData theme) => Container(
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
              Text(notif['titulo']!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(notif['hora']!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 12),
                  Text(notif['veterinario']!, style: theme.textTheme.bodySmall),
                  const SizedBox(width: 12),
                  Text(notif['mascota']!, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(width: 12),
              Text(notif['descripcion']!, style: theme.textTheme.bodySmall),
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
                child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 24) : null,
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
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
              if (!notificacionesRevisadas && notificacionesHoy.isNotEmpty)
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
                      '${notificacionesHoy.length}',
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
