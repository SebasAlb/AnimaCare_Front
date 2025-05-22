class Cita {
  String id;
  String mascotaId;
  String veterinarioId;
  String razon;
  String estado; // pendiente, cancelada, confirmada
  DateTime fecha;
  String hora;
  String? descripcion;

  Cita({
    required this.id,
    required this.mascotaId,
    required this.veterinarioId,
    required this.razon,
    required this.estado,
    required this.fecha,
    required this.hora,
    this.descripcion,
  });

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    id: json['id'].toString(),
    mascotaId: json['mascotaId'],
    veterinarioId: json['veterinarioId'],
    razon: json['razon'],
    estado: json['estado'],
    fecha: DateTime.parse(json['fecha']),
    hora: json['hora'],
    descripcion: json['descripcion'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'mascotaId': mascotaId,
    'veterinarioId': veterinarioId,
    'razon': razon,
    'estado': estado,
    'fecha': fecha.toIso8601String(),
    'hora': hora,
    'descripcion': descripcion,
  };
}
