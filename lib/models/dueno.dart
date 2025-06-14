class Dueno {
  int id;
  String nombre;
  String apellido;
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
    this.telefono,
    required this.correo,
    this.ciudad,
    this.direccion,
    required this.contrasena,
    this.fotoUrl,
  });

  factory Dueno.fromJson(Map<String, dynamic> json) => Dueno(
    id: json['id'],
    nombre: json['nombre'],
    apellido: json['apellido'],
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
    'telefono': telefono,
    'correo': correo,
    'ciudad': ciudad,
    'direccion': direccion,
    'contrasena': contrasena,
    'foto_url': fotoUrl,
  };

  Map<String, dynamic> toJsonWithoutPassword() => {
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'telefono': telefono,
    'correo': correo,
    'ciudad': ciudad,
    'direccion': direccion,
    'foto_url': fotoUrl,
  };

}
