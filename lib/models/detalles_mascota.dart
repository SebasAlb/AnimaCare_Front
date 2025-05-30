import 'package:animacare_front/models/cita.dart';
import 'package:animacare_front/models/evento.dart';
import 'package:animacare_front/models/historial_medico.dart';

class DetallesMascota {
  final int mascotaId;
  final String nombreMascota;
  final List<Cita> citas;
  final List<Evento> eventos;
  final List<HistorialMedico> historial;

  DetallesMascota({
    required this.mascotaId,
    required this.nombreMascota,
    required this.citas,
    required this.eventos,
    required this.historial,
  });

  factory DetallesMascota.fromJson(Map<String, dynamic> json) {
    return DetallesMascota(
      mascotaId: json['mascota_id'],
      nombreMascota: json['nombre_mascota'],
      citas: (json['citas'] as List).map((e) => Cita.fromJson(e)).toList(),
      eventos: (json['eventos'] as List).map((e) => Evento.fromJson(e)).toList(),
      historial: (json['historial_medico'] as List).map((e) => HistorialMedico.fromJson(e)).toList(),
    );
  }
}
