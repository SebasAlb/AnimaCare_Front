class Evento {
  int id;
  String titulo;
  DateTime fecha;
  DateTime hora;
  String? descripcion;
  int? categoriaId;
  int? mascotaId;
  int? veterinarioId;

  Evento({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.hora,
    this.descripcion,
    this.categoriaId,
    this.mascotaId,
    this.veterinarioId,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    titulo: json['titulo'] ?? '',
    fecha: DateTime.parse(json['fecha']),
    hora: DateTime.parse(json['hora']),
    descripcion: json['descripcion'],
    categoriaId: json['categoria_id'],
    mascotaId: json['mascota_id'],
    veterinarioId: json['veterinario_id'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'fecha': fecha.toIso8601String(),
    'hora': hora.toIso8601String(),
    'descripcion': descripcion,
    'categoria_id': categoriaId,
    'mascota_id': mascotaId,
    'veterinario_id': veterinarioId,
  };
  
}
