class HistorialMedico {
  int id;
  String titulo;
  String categoriaId;
  DateTime fecha;

  HistorialMedico({
    required this.id,
    required this.titulo,
    required this.categoriaId,
    required this.fecha,
  });

  factory HistorialMedico.fromJson(Map<String, dynamic> json) => HistorialMedico(
    id: json['id'],
    titulo: json['titulo'],
    categoriaId: json['categoria']?['id']?.toString() ?? '0', // ← Ajustado aquí
    fecha: DateTime.parse(json['fecha']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'categoria_id': categoriaId,
    'fecha': fecha.toIso8601String(),
  };
}