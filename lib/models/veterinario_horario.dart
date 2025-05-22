class VeterinarioHorario {
  String veterinarioId;
  String diaSemana;
  String horaInicio;
  String horaFin;

  VeterinarioHorario({
    required this.veterinarioId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
  });

  factory VeterinarioHorario.fromJson(Map<String, dynamic> json) => VeterinarioHorario(
    veterinarioId: json['veterinarioId'],
    diaSemana: json['diaSemana'],
    horaInicio: json['horaInicio'],
    horaFin: json['horaFin'],
  );

  Map<String, dynamic> toJson() => {
    'veterinarioId': veterinarioId,
    'diaSemana': diaSemana,
    'horaInicio': horaInicio,
    'horaFin': horaFin,
  };
}
