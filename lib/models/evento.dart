class Evento {
  int id;
  String titulo;
  DateTime fecha;
  DateTime hora;
  String? descripcion;

  Evento({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.hora,
    this.descripcion,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    titulo: json['titulo'],
    fecha: DateTime.parse(json['fecha']),
    hora: DateTime.parse(json['hora']),
    descripcion: json['descripcion'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'fecha': fecha.toIso8601String(),
    'hora': hora.toIso8601String(),
    'descripcion': descripcion,
  };
}