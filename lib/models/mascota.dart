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
  });

  String id;
  String nombre;
  String especie;
  String raza;
  DateTime fechaNacimiento;
  String sexo;
  double peso;
  double altura;
  String fotoUrl;

  factory Mascota.fromJson(Map<String, dynamic> json) => Mascota(
        id: json['id'].toString(),
        nombre: json['nombre'] ?? 'Sin nombre',
        especie: json['especie'] ?? 'Desconocida',
        raza: json['raza'] ?? 'Desconocida',
        fechaNacimiento: DateTime.tryParse(json['fecha_nacimiento'] ?? '') ?? DateTime(2000, 1, 1),
        sexo: json['sexo'] ?? 'Macho',
        peso: double.tryParse(json['peso'].toString()) ?? 0.0,
        altura: double.tryParse(json['altura'].toString()) ?? 0.0,
        fotoUrl: json['foto_url'] ?? '',
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

