class HistorialMedico {
  String id;
  String mascotaId;
  String titulo;
  String categoriaId;
  DateTime fecha;

  HistorialMedico({
    required this.id,
    required this.mascotaId,
    required this.titulo,
    required this.categoriaId,
    required this.fecha,
  });

  factory HistorialMedico.fromJson(Map<String, dynamic> json) => HistorialMedico(
    id: json['id'].toString(),
    mascotaId: json['mascotaId'],
    titulo: json['titulo'],
    categoriaId: json['categoriaId'],
    fecha: DateTime.parse(json['fecha']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'mascotaId': mascotaId,
    'titulo': titulo,
    'categoriaId': categoriaId,
    'fecha': fecha.toIso8601String(),
  };
}
