class VeterinarioHorario {
  int id;
  int veterinarioId;
  String diaSemana;
  String horaInicio;
  String horaFin;

  VeterinarioHorario({
    required this.id,
    required this.veterinarioId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
  });

  factory VeterinarioHorario.fromJson(Map<String, dynamic> json) => VeterinarioHorario(
    id: json['id'],
    veterinarioId: json['veterinario_id'],
    diaSemana: json['dia_semana'],
    horaInicio: json['hora_inicio'],
    horaFin: json['hora_fin'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'veterinario_id': veterinarioId,
    'dia_semana': diaSemana,
    'hora_inicio': horaInicio,
    'hora_fin': horaFin,
  };
}
