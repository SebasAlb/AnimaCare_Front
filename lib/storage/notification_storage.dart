import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class NotificationStorage {
  static final GetStorage _box = GetStorage();
  static const String _keyNotifications = 'notifications_data';
  static const String _keyReviewed = 'notifications_reviewed';

  /// Estructura de la notificación almacenada
  static Map<String, dynamic> _createNotificationData(
    EventoCalendar evento,
    bool revisado,
  ) {
    return {
      ...evento.toJson(),
      'revisado': revisado,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Guarda una nueva notificación
  static void saveNotification(EventoCalendar evento) {
    final List<Map<String, dynamic>> existingData = getAllNotifications();

    // Verifica si la notificación ya existe
    final exists = existingData.any((item) => item['id'] == evento.id);
    if (!exists) {
      existingData.add(_createNotificationData(evento, false));
      _box.write(_keyNotifications, existingData);
    }
  }

  /// Obtiene todas las notificaciones
  static List<Map<String, dynamic>> getAllNotifications() {
    final data = _box.read(_keyNotifications);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(data);
  }

  /// Obtiene solo las notificaciones no revisadas
  static List<Map<String, dynamic>> getUnreviewedNotifications() {
    return getAllNotifications().where((notif) => !notif['revisado']).toList();
  }

  /// Marca todas las notificaciones como revisadas
  static void markAllAsReviewed() {
    final notifications = getAllNotifications();
    for (var notification in notifications) {
      notification['revisado'] = true;
    }
    _box.write(_keyNotifications, notifications);
  }

  /// Marca una notificación específica como revisada
  static void markAsReviewed(String notificationId) {
    final notifications = getAllNotifications();
    final index = notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      notifications[index]['revisado'] = true;
      _box.write(_keyNotifications, notifications);
    }
  }

  /// Elimina notificaciones antiguas (más de 30 días)
  static void cleanOldNotifications() {
    final notifications = getAllNotifications();
    final now = DateTime.now();
    notifications.removeWhere((notification) {
      final timestamp = DateTime.parse(notification['timestamp']);
      final difference = now.difference(timestamp);
      return difference.inDays > 30;
    });
    _box.write(_keyNotifications, notifications);
  }

  /// Elimina una notificación específica
  static void removeNotification(String notificationId) {
    final notifications = getAllNotifications();
    notifications
        .removeWhere((notification) => notification['id'] == notificationId);
    _box.write(_keyNotifications, notifications);
  }

  /// Limpia todas las notificaciones
  static void clearAllNotifications() {
    _box.remove(_keyNotifications);
  }
}
