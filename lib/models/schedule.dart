import 'package:animacare_front/models/cita.dart';
import 'package:animacare_front/models/evento.dart';

class ScheduleItem  {
  final int mascotaId;
  final String nombreMascota;
  final List<Cita> citas;
  final List<Evento> eventos;

  ScheduleItem ({
    required this.mascotaId,
    required this.nombreMascota,
    required this.citas,
    required this.eventos,
  });

  factory ScheduleItem .fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      mascotaId: json['mascota_id'],
      nombreMascota: json['nombre_mascota'],
      citas: (json['citas'] as List).map((e) => Cita.fromJson(e)).toList(),
      eventos: (json['eventos'] as List).map((e) => Evento.fromJson(e)).toList(),
    );
  }
}
