class Cita {
  int id;
  String razon;
  String estado;
  DateTime fecha;
  DateTime hora;
  String? descripcion;

  Cita({
    required this.id,
    required this.razon,
    required this.estado,
    required this.fecha,
    required this.hora,
    this.descripcion,
  });

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    id: json['id'],
    razon: json['razon_cita'],
    estado: json['estado'],
    fecha: DateTime.parse(json['fecha']),
    hora: DateTime.parse(json['hora']),
    descripcion: json['descripcion'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'razon_cita': razon,
    'estado': estado,
    'fecha': fecha.toIso8601String(),
    'hora': hora.toIso8601String(),
    'descripcion': descripcion,
  };
}