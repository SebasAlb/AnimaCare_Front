import 'veterinario.dart';

class Cita {
  int id;
  String razon;
  String estado;
  DateTime fecha;
  DateTime hora;
  String? descripcion;
  int? mascotaId; // ✅ NUEVO
  int? veterinarioId; // ✅ NUEVO
  Veterinario? veterinario; // ✅ NUEVO

  Cita({
    required this.id,
    required this.razon,
    required this.estado,
    required this.fecha,
    required this.hora,
    this.descripcion,
    this.mascotaId, // ✅
    this.veterinarioId, // ✅
    this.veterinario, // ✅ NUEVO
  });

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    id: json['id'],
    razon: json['razon_cita'],
    estado: json['estado'],
    fecha: DateTime.parse(json['fecha']),
    hora: DateTime.parse(json['hora']),
    descripcion: json['descripcion'],
    mascotaId: json['mascota_id'], // ✅
    veterinarioId: json['veterinario']?['id'] ?? json['veterinario_id'], // ✅   
    veterinario: json['veterinario'] != null
            ? Veterinario.fromJson({
                ...json['veterinario'],
                'horarios': [],
                'excepciones': [],
              })
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'razon_cita': razon,
    'estado': estado,
    'fecha': fecha.toIso8601String(),
    'hora': hora.toIso8601String(),
    'descripcion': descripcion,
    'mascota_id': mascotaId, // ✅ para el backend
    'veterinario_id': veterinarioId, // ✅ para el backend
  };
}
