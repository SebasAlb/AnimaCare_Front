import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/services/pet_service.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_screen.dart';
import 'package:animacare_front/services/sound_service.dart';

import 'package:animacare_front/storage/pet_storage.dart'; // NUEVO
import 'package:animacare_front/services/event_service.dart';

class HomeController extends ChangeNotifier {
  final List<Mascota> _mascotas = [];
  bool _isLoading = true;

  final PetService _petService = PetService();

  List<Mascota> get mascotas => _mascotas;
  bool get isLoading => _isLoading;
  bool _isEliminando = false;
  bool get isEliminando => _isEliminando;

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
      
      // Filtrar mascotas activas (sin deleted_at)
      final activas = desdeApi.where((m) => m.deletedAt == null).toList();

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
  Future<void> eliminarMascotaConEventos(Mascota mascota) async {
    _isEliminando = true;
    notifyListeners();

    try {
      final detalles = await _petService.obtenerDetallesMascota(mascota.id);
      for (final evento in detalles.eventos) {
        await EventService().eliminarEvento(evento.id);
      }

      await _petService.eliminarMascota(mascota.id);

      SoundService.playSuccess();
    } catch (e) {
      debugPrint('Error al eliminar mascota: $e');
    }

    _isEliminando = false;
    await cargarMascotasDesdeApi(); // Refresca
  }

  void limpiarMascotasCache() {
  MascotasStorage.clearMascotas();
}

  
}











