import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/services/pet_service.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_screen.dart';
import 'package:animacare_front/services/sound_service.dart';

import 'package:animacare_front/storage/pet_storage.dart'; // NUEVO

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

      // Cargar desde storage si existe
      if (MascotasStorage.hasMascotas()) {
        final cacheadas = MascotasStorage.getMascotas();
        _mascotas
          ..clear()
          ..addAll(cacheadas);
        _isLoading = false;
        notifyListeners();
      }

      // Cargar desde API (siempre lo hace para mantener actualizado)
      final List<Mascota> desdeApi = await _petService.obtenerMascotasPorDueno(dueno.id);
      _mascotas
        ..clear()
        ..addAll(desdeApi);
      MascotasStorage.saveMascotas(desdeApi);
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

  void limpiarMascotasCache() {
  MascotasStorage.clearMascotas();
}

  
}




