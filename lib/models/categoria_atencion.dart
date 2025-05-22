class CategoriaAtencion {
  String id;
  String nombre; // vacuna, desparasitación, etc.

  CategoriaAtencion({
    required this.id,
    required this.nombre,
  });

  factory CategoriaAtencion.fromJson(Map<String, dynamic> json) => CategoriaAtencion(
    id: json['id'].toString(),
    nombre: json['nombre'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
  };
}
