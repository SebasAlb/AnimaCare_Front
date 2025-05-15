class EventoCalendar {

  EventoCalendar({
    required this.id,
    required this.titulo,
    required this.hora,
    required this.fecha,
    required this.mascota,
    required this.veterinario,
    required this.tipo,
    this.categoria,
    this.estado,
    this.descripcion,
  });

  /// Crea una instancia desde JSON (útil para backend)
  factory EventoCalendar.fromJson(Map<String, dynamic> json) => EventoCalendar(
      id: json['id'].toString(),
      titulo: json['titulo'],
      hora: json['hora'],
      fecha: json['fecha'],
      mascota: json['mascota'],
      veterinario: json['veterinario'],
      tipo: json['tipo'],
      categoria: json['categoria'],
      estado: json['estado'],
      descripcion: json['descripcion'],
    );
  final String id;
  final String titulo;
  final String hora;
  final String fecha; // formato: yyyy-MM-dd
  final String mascota;
  final String veterinario;
  final String tipo; // 'cita' o 'evento'
  final String? categoria;
  final String? estado; // solo para citas
  final String? descripcion;

  /// Verdadero si el evento es una cita (tipo = 'cita')
  bool get esCita => tipo.toLowerCase() == 'cita';

  /// Convierte el objeto a JSON (útil para enviar datos al backend)
  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'titulo': titulo,
      'hora': hora,
      'fecha': fecha,
      'mascota': mascota,
      'veterinario': veterinario,
      'tipo': tipo,
      'categoria': categoria,
      'estado': estado,
      'descripcion': descripcion,
    };
}
