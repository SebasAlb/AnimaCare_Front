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

  factory Mascota.fromJson(Map<String, dynamic> json) => Mascota(
        id: json['id'].toString(),
        nombre: json['nombre'],
        especie: json['especie'],
        raza: json['raza'],
        fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
        sexo: json['sexo'],
        peso: double.tryParse(json['peso'].toString()) ?? 0,
        altura: double.tryParse(json['altura'].toString()) ?? 0,
        fotoUrl: json['fotoUrl'] ?? '',
      );
  //quitamos los final de los campos
  String id;
  String nombre;
  String especie;
  String raza;
  DateTime fechaNacimiento;
  String sexo;
  double peso;
  double altura;
  String fotoUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'nombre': nombre,
        'especie': especie,
        'raza': raza,
        'fechaNacimiento': fechaNacimiento.toIso8601String(),
        'sexo': sexo,
        'peso': peso,
        'altura': altura,
        'fotoUrl': fotoUrl,
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
