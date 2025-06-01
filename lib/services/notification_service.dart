import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class NotificationService {
  static const String channelKey = 'anima_channel';

  /// Programa una notificación para un evento o cita
  static Future<void> programarNotificacion(EventoCalendar evento) async {
    final DateTime fechaEvento = DateTime.parse('${evento.fecha} ${evento.hora}');
    final DateTime fechaNotificacion = fechaEvento.subtract(const Duration(days: 1));

    if (fechaNotificacion.isBefore(DateTime.now())) {
      print('------------------[NOTIF] No se programa: ${evento.titulo} (fecha pasada)');
      return;
    }

    final int id = int.tryParse(evento.id) ?? DateTime.now().millisecondsSinceEpoch;

    print('**************[NOTIF] Programando notificación: ${evento.id} - ${evento.titulo} → $fechaEvento');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channelKey,
        title: '⏰ Recordatorio: ${evento.titulo}',
        body: '${evento.tipo == 'cita' ? 'Tienes una cita' : 'Tienes un evento'} con ${evento.mascota} mañana a las ${evento.hora}.',
        notificationLayout: NotificationLayout.BigText,
        payload: {
          'tipo': evento.tipo,
          'mascota': evento.mascota,
          'veterinario': evento.veterinario,
        },
      ),
      schedule: NotificationCalendar(
        year: fechaNotificacion.year,
        month: fechaNotificacion.month,
        day: fechaNotificacion.day,
        hour: fechaNotificacion.hour,
        minute: fechaNotificacion.minute,
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
