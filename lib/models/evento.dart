class Evento {
  String id;
  String titulo;
  String categoriaId;
  String mascotaId;
  String veterinarioId;
  DateTime fecha;
  String hora;
  String? descripcion;

  Evento({
    required this.id,
    required this.titulo,
    required this.categoriaId,
    required this.mascotaId,
    required this.veterinarioId,
    required this.fecha,
    required this.hora,
    this.descripcion,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'].toString(),
    titulo: json['titulo'],
    categoriaId: json['categoriaId'],
    mascotaId: json['mascotaId'],
    veterinarioId: json['veterinarioId'],
    fecha: DateTime.parse(json['fecha']),
    hora: json['hora'],
    descripcion: json['descripcion'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'categoriaId': categoriaId,
    'mascotaId': mascotaId,
    'veterinarioId': veterinarioId,
    'fecha': fecha.toIso8601String(),
    'hora': hora,
    'descripcion': descripcion,
  };
}
