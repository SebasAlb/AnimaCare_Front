class Dueno {
  String id;
  String nombre;
  String apellido;
  String cedula;
  String? telefono;
  String correo;
  String? ciudad;
  String? direccion;
  String contrasena;
  String? fotoUrl;

  Dueno({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    this.telefono,
    required this.correo,
    this.ciudad,
    this.direccion,
    required this.contrasena,
    this.fotoUrl,
  });

  factory Dueno.fromJson(Map<String, dynamic> json) => Dueno(
    id: json['id'].toString(),
    nombre: json['nombre'],
    apellido: json['apellido'],
    cedula: json['cedula'],
    telefono: json['telefono'],
    correo: json['correo'],
    ciudad: json['ciudad'],
    direccion: json['direccion'],
    contrasena: json['contrasena'],
    fotoUrl: json['foto_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'cedula': cedula,
    'telefono': telefono,
    'correo': correo,
    'ciudad': ciudad,
    'direccion': direccion,
    'contrasena': contrasena,
    'foto_url': fotoUrl,
  };
}
