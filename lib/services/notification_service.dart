import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class NotificationService {
  static const String channelKey = 'anima_channel';

  /// Programa una notificación para un evento o cita
  static Future<void> programarNotificacion(EventoCalendar evento) async {
    final DateTime fechaHora = DateTime.parse('${evento.fecha} ${evento.hora}');

    if (fechaHora.isBefore(DateTime.now())) {
      print('------------------[NOTIF] No se programa: ${evento.titulo} (fecha pasada)');
      return;
    }

    final int id = int.tryParse(evento.id) ?? DateTime.now().millisecondsSinceEpoch;

    print('**************[NOTIF] Programando notificación: ${evento.id} - ${evento.titulo} → $fechaHora');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: evento.titulo,
        body: '${evento.tipo == 'cita' ? 'Cita' : 'Evento'} de ${evento.mascota} con ${evento.veterinario}',
        notificationLayout: NotificationLayout.Default,
        payload: {
          'tipo': evento.tipo,
          'mascota': evento.mascota,
          'veterinario': evento.veterinario,
        },
      ),
      schedule: NotificationCalendar(
        year: fechaHora.year,
        month: fechaHora.month,
        day: fechaHora.day,
        hour: fechaHora.hour,
        minute: fechaHora.minute,
        second: 0,
        millisecond: 0,
        repeats: false,
      ),
    );
  }

  /// Elimina una notificación específica
  static Future<void> eliminarNotificacion(String id) async {
    final int notifId = int.tryParse(id) ?? -1;
    if (notifId != -1) {
      await AwesomeNotifications().cancel(notifId);
    }
  }

  /// Verifica si ya existe una notificación programada
  static Future<bool> existeNotificacion(String id) async {
    final int notifId = int.tryParse(id) ?? -1;
    if (notifId == -1) return false;

    final List<NotificationModel> notifs = await AwesomeNotifications().listScheduledNotifications();
    return notifs.any((n) => n.content?.id == notifId);
  }

  /// Actualiza una notificación reprogramándola
  static Future<void> actualizarNotificacion(EventoCalendar evento) async {
    await eliminarNotificacion(evento.id);
    await programarNotificacion(evento);
  }

  /// Cancela todas las notificaciones programadas
  static Future<void> eliminarTodas() async {
    await AwesomeNotifications().cancelAll();
  }

  static Future<void> debugMostrarNotificacionesProgramadas() async {
    final List<NotificationModel> scheduled =
    await AwesomeNotifications().listScheduledNotifications();
    print('🔔 Notificaciones programadas (${scheduled.length}):');
    for (final notif in scheduled) {
      print('→ ID ${notif.content?.id} : ${notif.content?.title} @ ${notif.schedule}');
    }
  }
}
