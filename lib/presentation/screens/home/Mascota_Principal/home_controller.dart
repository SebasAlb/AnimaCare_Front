import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_screen.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final List<Mascota> _mascotas = <Mascota>[];

  List<Mascota> get mascotas => _mascotas;

  void cargarMascotasIniciales() {
    _mascotas.clear();
    _mascotas.addAll(<Mascota>[
      Mascota(
        id: '1',
        nombre: 'Michi',
        especie: 'Gato',
        raza: 'Siames',
        fechaNacimiento: DateTime(2021, 5, 10),
        sexo: 'Macho',
        peso: 4.2,
        altura: 30.0,
        fotoUrl: '', // puedes usar un asset de momento
      ),
      Mascota(
        id: '2',
        nombre: 'Firulais',
        especie: 'Perro',
        raza: 'Labrador',
        fechaNacimiento: DateTime(2020, 2, 3),
        sexo: 'Hembra',
        peso: 20.5,
        altura: 60.0,
        fotoUrl: '',
      ),
    ]);
    notifyListeners();
  }

  void agregarMascota(Mascota nueva) {
    _mascotas.add(nueva);
    notifyListeners();
  }

  void onAgregarMascota(BuildContext context) async {
    final Mascota? nueva = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AgregarMascotaScreen(),
      ),
    );

    if (nueva != null) {
      agregarMascota(nueva);
    }
  }
}
