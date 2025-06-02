import 'veterinario.dart'; // asegúrate de importar este modelo
import 'categoria_atencion.dart';

class Evento {
  int id;
  String titulo;
  DateTime fecha;
  DateTime hora;
  String? descripcion;
  int? categoriaId;
  int? mascotaId;
  int? veterinarioId;
  Veterinario? veterinario; // ✅ NUEVO
  CategoriaAtencion? categoria; // ✅ NUEVO

  Evento({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.hora,
    this.descripcion,
    this.categoriaId,
    this.mascotaId,
    this.veterinarioId,
    this.veterinario, // ✅
    this.categoria,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json['id'],
        titulo: json['titulo'] ?? '',
        fecha: DateTime.parse(json['fecha']),
        hora: DateTime.parse(json['hora']),
        descripcion: json['descripcion'],
        categoriaId: json['categoria']?['id'] ?? json['categoria_id'],
        mascotaId: json['mascota_id'],
        veterinarioId: json['veterinario']?['id'] ?? json['veterinario_id'],
        veterinario: json['veterinario'] != null
            ? Veterinario.fromJson({
                ...json['veterinario'],
                'horarios': [], // para evitar error si backend no los manda
                'excepciones': [],
              })
            : null,
        categoria: json['categoria'] != null
          ? CategoriaAtencion.fromJson(json['categoria'])
          : null,
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
        // ❌ NO incluir `veterinario` al enviar, solo el ID
      };
}

