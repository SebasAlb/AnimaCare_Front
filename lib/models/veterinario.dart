import 'veterinario_horario.dart';

class Veterinario {
  String id;
  String nombre;
  String apellido;
  String cedulaProfesional;
  String telefono;
  String correo;
  String rol;
  DateTime fechaIngreso;
  String fotoUrl;
  String estado;
  Map<String, String> horario;
  List<VeterinarioHorario>? horariosDetalle; // ✅ NUEVO CAMPO

  Veterinario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.cedulaProfesional,
    required this.telefono,
    required this.correo,
    required this.rol,
    required this.fechaIngreso,
    required this.fotoUrl,
    required this.estado,
    required this.horario,
    this.horariosDetalle, // ✅ CONSTRUCTOR
  });

  factory Veterinario.fromJson(Map<String, dynamic> json) => Veterinario(
        id: json['id'].toString(),
        nombre: json['nombre'],
        apellido: json['apellido'],
        cedulaProfesional: json['cedulaProfesional'],
        telefono: json['telefono'],
        correo: json['correo'],
        rol: json['rol'],
        fechaIngreso: DateTime.parse(json['fechaIngreso']),
        fotoUrl: json['fotoUrl'] ?? '',
        estado: json['estado'] ?? 'Disponible',
        horario: Map<String, String>.from(json['horario'] ?? {}),
        horariosDetalle: (json['horariosDetalle'] as List<dynamic>?)
            ?.map((h) => VeterinarioHorario.fromJson(h))
            .toList(), // ✅ JSON compatible
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'cedulaProfesional': cedulaProfesional,
        'telefono': telefono,
        'correo': correo,
        'rol': rol,
        'fechaIngreso': fechaIngreso.toIso8601String(),
        'fotoUrl': fotoUrl,
        'estado': estado,
        'horario': horario,
        'horariosDetalle': horariosDetalle?.map((h) => h.toJson()).toList(), // ✅ JSON
      };

  String get nombreCompleto => '$nombre $apellido';
}
