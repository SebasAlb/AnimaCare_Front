class VeterinarioExcepcion {
  int id;
  int veterinarioId;
  DateTime fecha;
  String horaInicio;
  String horaFin;
  String motivo;
  bool disponible;

  VeterinarioExcepcion({
    required this.id,
    required this.veterinarioId,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.motivo,
    required this.disponible,
  });

  factory VeterinarioExcepcion.fromJson(Map<String, dynamic> json) => VeterinarioExcepcion(
    id: json['id'],
    veterinarioId: json['veterinario_id'],
    fecha: DateTime.parse(json['fecha']),
    horaInicio: json['hora_inicio'],
    horaFin: json['hora_fin'],
    motivo: json['motivo'],
    disponible: json['disponible'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'veterinario_id': veterinarioId,
    'fecha': fecha.toIso8601String(),
    'hora_inicio': horaInicio,
    'hora_fin': horaFin,
    'motivo': motivo,
    'disponible': disponible,
  };
}
