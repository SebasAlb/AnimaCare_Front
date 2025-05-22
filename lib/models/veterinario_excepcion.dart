class VeterinarioExcepcion {
  String veterinarioId;
  DateTime fechaInicio;
  DateTime fechaFin;
  String motivo;
  bool disponible;

  VeterinarioExcepcion({
    required this.veterinarioId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.motivo,
    required this.disponible,
  });

  factory VeterinarioExcepcion.fromJson(Map<String, dynamic> json) => VeterinarioExcepcion(
    veterinarioId: json['veterinarioId'],
    fechaInicio: DateTime.parse(json['fechaInicio']),
    fechaFin: DateTime.parse(json['fechaFin']),
    motivo: json['motivo'],
    disponible: json['disponible'],
  );

  Map<String, dynamic> toJson() => {
    'veterinarioId': veterinarioId,
    'fechaInicio': fechaInicio.toIso8601String(),
    'fechaFin': fechaFin.toIso8601String(),
    'motivo': motivo,
    'disponible': disponible,
  };
}
