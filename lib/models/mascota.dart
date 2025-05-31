class Mascota {
  Mascota({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.fechaNacimiento,
    required this.sexo,
    required this.peso,
    required this.altura,
    required this.fotoUrl,
    this.deletedAt,
  });

  int id;
  String nombre;
  String especie;
  String raza;
  DateTime fechaNacimiento;
  String sexo;
  double peso;
  double altura;
  String fotoUrl;
  DateTime? deletedAt;

  factory Mascota.fromJson(Map<String, dynamic> json) => Mascota(
        id: int.tryParse(json['id'].toString()) ?? 0,
        nombre: json['nombre'] ?? 'Sin nombre',
        especie: json['especie'] ?? 'Desconocida',
        raza: json['raza'] ?? 'Desconocida',
        fechaNacimiento: DateTime.tryParse(json['fecha_nacimiento'] ?? '') ?? DateTime(2000, 1, 1),
        sexo: json['sexo'] ?? 'Macho',
        peso: double.tryParse(json['peso'].toString()) ?? 0.0,
        altura: double.tryParse(json['altura'].toString()) ?? 0.0,
        fotoUrl: json['foto_url'] ?? '',
        deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null, 
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'nombre': nombre,
        'especie': especie,
        'raza': raza,
        'fecha_nacimiento': fechaNacimiento.toIso8601String(),
        'sexo': sexo,
        'peso': peso,
        'altura': altura,
        'foto_url': fotoUrl,
        'deleted_at': deletedAt?.toIso8601String(),
      };

  String get edadFormateada {
    final DateTime ahora = DateTime.now();
    int anios = ahora.year - fechaNacimiento.year;
    int meses = ahora.month - fechaNacimiento.month;
    if (meses < 0) {
      anios--;
      meses += 12;
    }
    return '$anios años y $meses meses';
  }
}


