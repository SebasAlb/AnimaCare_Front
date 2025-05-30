class CategoriaAtencion {
  int id;
  String nombre;

  CategoriaAtencion({
    required this.id,
    required this.nombre,
  });

  factory CategoriaAtencion.fromJson(Map<String, dynamic> json) => CategoriaAtencion(
    id: json['id'],
    nombre: json['nombre'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
  };
}