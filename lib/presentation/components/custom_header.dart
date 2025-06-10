import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:animacare_front/storage/notification_storage.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';
import 'package:animacare_front/services/owner_service.dart';
import 'package:animacare_front/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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
  bool notificacionesCargando = true;

  @override
  void initState() {
    super.initState();
    dueno = UserStorage.getUser();
    _cargarNotificacionesHoy();

    // Solo para debug
    NotificationService.debugMostrarNotificacionesProgramadas();
  }

  Future<void> _cargarNotificacionesHoy() async {
    final duenoId = dueno?.id;
    if (duenoId == null) {
      setState(() =>
          notificacionesCargando = false); // <- Evita que se quede cargando
      return;
    }

    try {
      final mascotas = await _ownerService.obtenerCitasYEventos(duenoId);
      final DateTime ahora = DateTime.now();
      final List<EventoCalendar> acumulado = [];

      for (final mascota in mascotas) {
        for (final e in mascota.eventos) {
          final DateTime fechaHoraEvento = DateTime(
            e.fecha.year,
            e.fecha.month,
            e.fecha.day,
            e.hora.hour,
            e.hora.minute,
          );
          print(
              '---------- [DEBUG] Veterinario evento: ${e.veterinario?.nombre} ${e.veterinario?.apellido}');

          if (fechaHoraEvento.isAfter(ahora)) {
            final evento = EventoCalendar(
              id: e.id.toString(),
              titulo: e.titulo,
              hora: _formatoHora(e.hora),
              fecha: _formatoFecha(e.fecha),
              mascota: mascota.nombreMascota,
              veterinario: e.veterinario != null
                  ? '${e.veterinario!.nombre} ${e.veterinario!.apellido}'
                  : '',
              tipo: 'evento',
              categoria: null,
              estado: null,
              descripcion: e.descripcion,
            );
            acumulado.add(evento);

            final yaExiste =
                await NotificationService.existeNotificacion(evento.id);
            if (!yaExiste) {
              await NotificationService.programarNotificacion(evento);
            }
          }
        }

        for (final c in mascota.citas) {
          final DateTime fechaHoraCita = DateTime(
            c.fecha.year,
            c.fecha.month,
            c.fecha.day,
            c.hora.hour,
            c.hora.minute,
          );
          print(
              '*********** [DEBUG] Veterinario cita: ${c.veterinario?.nombre} ${c.veterinario?.apellido}');

          if (fechaHoraCita.isAfter(ahora) &&
              c.estado.toLowerCase() == 'confirmada') {
            final cita = EventoCalendar(
              id: c.id.toString(),
              titulo: c.razon,
              hora: _formatoHora(c.hora),
              fecha: _formatoFecha(c.fecha),
              mascota: mascota.nombreMascota,
              veterinario: c.veterinario != null
                  ? '${c.veterinario!.nombre} ${c.veterinario!.apellido}'
                  : '',
              tipo: 'cita',
              categoria: null,
              estado: c.estado,
              descripcion: c.descripcion,
            );
            acumulado.add(cita);

            final yaExiste =
                await NotificationService.existeNotificacion(cita.id);
            if (!yaExiste) {
              await NotificationService.programarNotificacion(cita);
            }
          }
        }
      }

      acumulado.sort((a, b) {
        final dtA = DateTime.parse('${a.fecha} ${a.hora}');
        final dtB = DateTime.parse('${b.fecha} ${b.hora}');
        return dtA.compareTo(dtB);
      });

      // Guardar cada notificación en el storage
      for (final evento in acumulado) {
        NotificationStorage.saveNotification(evento);
      }

      setState(() {
        notificacionesHoy = acumulado;
        notificacionesCargando = false;
      });
    } catch (e) {
      setState(() {
        notificacionesHoy = [];
        notificacionesCargando = false; // <- IMPORTANTE
      });
    }
  }

  String formatearFechaBonita(String fechaIso) {
    try {
      final DateTime fecha = DateTime.parse(fechaIso);
      final DateFormat formato = DateFormat("d 'de' MMMM 'del' y", 'es_ES');
      final fechaFormateada = formato.format(fecha);
      return fechaFormateada[0].toUpperCase() + fechaFormateada.substring(1);
    } catch (e) {
      return fechaIso;
    }
  }

  void _mostrarNotificaciones(BuildContext context) {
    if (notificacionesCargando) {
      Get.snackbar(
        'Cargando...',
        'Estamos cargando tus notificaciones, por favor espera.',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.notifications_active,
            color: Colors.deepOrangeAccent),
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Marcar todas las notificaciones como revisadas
    NotificationStorage.markAllAsReviewed();

    setState(() => notificacionesRevisadas = true);
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // This is key for full height but also for full width
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false, // Set to true to expand horizontally and vertically
        maxChildSize: 0.85,
        minChildSize: 0.4,
        initialChildSize: 0.5,
        builder: (context, scrollController) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              // Add padding directly to the content if needed
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: Text(
                'Notificaciones',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (notificacionesHoy.isEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('No tienes notificaciones...',
                    style: theme.textTheme.bodyMedium),
              ),
            Expanded(
              // Use Expanded to make the list of notifications take remaining space
              child: ListView.builder(
                controller: scrollController,
                itemCount: notificacionesHoy.length,
                itemBuilder: (context, index) {
                  final notif = notificacionesHoy[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16), // Apply horizontal padding here
                    child: _notificacionCard({
                      'titulo': notif.titulo,
                      'mascota': notif.mascota,
                      'fecha': notif.fecha,
                      'hora': notif.hora,
                      'veterinario': notif.veterinario,
                      'descripcion': notif.descripcion ?? '',
                      'tipo': notif.tipo,
                      'categoria': notif.categoria ?? '',
                      'estado': notif.estado ?? '',
                    }, theme),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatoFecha(DateTime fecha) =>
      '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';

  String _formatoHora(DateTime hora) =>
      '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

  String _formatoHora24H(DateTime hora) {
    return DateFormat('HH:mm').format(hora); // HH for 24-hour format
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
            Icon(Icons.notifications_active,
                color: theme.colorScheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(notif['titulo']!,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const Spacer(), // This pushes the following widget to the right
                    Text(
                        _formatoHora24H(DateTime.parse(
                            '2000-01-01 ${notif['hora']!}')), // Parse the time string
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                  ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatearFechaBonita(notif['fecha']!),
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      if (notif['tipo']!.isNotEmpty)
                        Text('Tipo: ${notif['tipo']!}',
                            style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text('Mascota: 🐾' + notif['mascota']!,
                          style: theme.textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text('Veterinario: 👤' + notif['veterinario']!,
                          style: theme.textTheme.bodySmall),
                      if (notif['categoria']!.isNotEmpty)
                        Text('Categoría: 🗂 ${notif['categoria']!}',
                            style: theme.textTheme.bodySmall),
                      if (notif['estado']!.isNotEmpty)
                        Text('Estado: ${notif['estado']!}',
                            style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (notif['descripcion']!.isNotEmpty &&
                      notif['descripcion'] != ' ')
                    Text(' ➤ ' + notif['descripcion']!,
                        style: theme.textTheme.bodySmall),
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
    // Modificar la condición para mostrar el contador de notificaciones
    final unreviewedNotifications =
        NotificationStorage.getUnreviewedNotifications();
    final hasUnreviewedNotifications = unreviewedNotifications.isNotEmpty;

    if (widget.isSecondaryScreen && !widget.mostrarMascota) {
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
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor),
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

    if (widget.isSecondaryScreen && widget.mostrarMascota) {
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
            const SizedBox(width: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text(
                widget.nameScreen,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
            ),
            const Spacer(), // This pushes everything after it to the far right
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: textColor),
                  onPressed: () {
                    SoundService.playButton();
                    _mostrarNotificaciones(context);
                  },
                ),
                if (hasUnreviewedNotifications)
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
                        '${unreviewedNotifications.length}',
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  SoundService.playButton();
                  Get.toNamed(AppRoutes.settingsP);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white24,
                  backgroundImage:
                      avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.white, size: 24)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
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
                onPressed: () {
                  SoundService.playButton();
                  _mostrarNotificaciones(context);
                },
              ),
              if (hasUnreviewedNotifications)
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
                      '${unreviewedNotifications.length}',
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
