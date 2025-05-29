import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/services/pet_service.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_screen.dart';
import 'package:animacare_front/services/sound_service.dart';

class HomeController extends ChangeNotifier {
  final List<Mascota> _mascotas = [];
  bool _isLoading = true;

  final PetService _petService = PetService();

  List<Mascota> get mascotas => _mascotas;
  bool get isLoading => _isLoading;

  Future<void> cargarMascotasDesdeApi() async {
    _isLoading = true;
    notifyListeners();

    try {
      final Dueno? dueno = UserStorage.getUser();
      if (dueno == null) throw Exception("Usuario no autenticado");

      final List<Mascota> lista = await _petService.obtenerMascotasPorDueno(dueno.id);
      _mascotas
        ..clear()
        ..addAll(lista);
    } catch (e) {
      print("Error al obtener mascotas: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> onAgregarMascota(BuildContext context) async {
    SoundService.playButton();
    final Mascota? nueva = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AgregarMascotaScreen(),
      ),
    );
    
    if (nueva != null) {
      _mascotas.add(nueva);
      notifyListeners();
    }
  }
  
}


