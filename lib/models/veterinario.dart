import 'veterinario_horario.dart';
import 'veterinario_excepcion.dart';

class Veterinario {
  int id;
  String nombre;
  String apellido;
  String cedulaProfesional;
  String telefono;
  String correo;
  String rol;
  DateTime fechaIngreso;
  String fotoUrl;
  List<VeterinarioHorario> horarios;
  List<VeterinarioExcepcion> excepciones;

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
    required this.horarios,
    required this.excepciones,
  });

  factory Veterinario.fromJson(Map<String, dynamic> json) => Veterinario(
    id: json['id'],
    nombre: json['nombre'],
    apellido: json['apellido'],
    cedulaProfesional: json['cedula_profesional'],
    telefono: json['telefono'] ?? '',
    correo: json['correo'] ?? '',
    rol: json['rol'],
    fechaIngreso: DateTime.parse(json['fecha_ingreso']),
    fotoUrl: json['foto_url'] ?? '',
    horarios: (json['horarios'] as List)
        .map((h) => VeterinarioHorario.fromJson(h))
        .toList(),
    excepciones: (json['excepciones'] as List)
        .map((e) => VeterinarioExcepcion.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'cedula_profesional': cedulaProfesional,
    'telefono': telefono,
    'correo': correo,
    'rol': rol,
    'fecha_ingreso': fechaIngreso.toIso8601String(),
    'foto_url': fotoUrl,
    'horarios': horarios.map((h) => h.toJson()).toList(),
    'excepciones': excepciones.map((e) => e.toJson()).toList(),
  };

  String get nombreCompleto => '$nombre $apellido';
}
