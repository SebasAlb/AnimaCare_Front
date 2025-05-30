import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/models/mascota.dart';

class MascotasStorage {
  static final GetStorage _box = GetStorage();
  static const String _key = 'mascotas_data';

  // Guardar lista de mascotas
  static void saveMascotas(List<Mascota> mascotas) {
    final List<Map<String, dynamic>> jsonList =
        mascotas.map((m) => m.toJson()).toList();
    _box.write(_key, jsonList);
  }

  // Obtener lista de mascotas
  static List<Mascota> getMascotas() {
    final data = _box.read<List>(_key);
    if (data == null) return [];
    return data
        .map((json) => Mascota.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  // Obtener una mascota específica por ID
  static Mascota? getMascotaById(int id) {
    final data = _box.read<List>(_key);
    if (data == null) return null;

    try {
      final json = data.firstWhere((item) => item['id'] == id);
      return Mascota.fromJson(Map<String, dynamic>.from(json));
    } catch (_) {
      return null;
    }
  }

  // Eliminar la caché
  static void clearMascotas() {
    _box.remove(_key);
  }

  // Verificar si existen datos cacheados
  static bool hasMascotas() {
    return _box.hasData(_key);
  }
}
