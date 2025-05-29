import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/models/veterinario.dart';

class VeterinariosStorage {
  static final GetStorage _box = GetStorage();
  static const String _key = 'veterinarios_data';

  static void saveVeterinarios(List<Veterinario> veterinarios) {
    final List<Map<String, dynamic>> jsonList =
    veterinarios.map((v) => v.toJson()).toList();
    _box.write(_key, jsonList);
  }

  static List<Veterinario> getVeterinarios() {
    final data = _box.read<List>(_key);
    if (data == null) return [];
    return data
        .map((json) => Veterinario.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Veterinario? getVeterinarioById(int id) {
    final data = _box.read<List>(_key);
    if (data == null) return null;

    try {
      final json = data.firstWhere((item) => item['id'] == id);
      return Veterinario.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      return null;
    }
  }

  static void clearVeterinarios() {
    _box.remove(_key);
  }

  static bool hasVeterinarios() {
    return _box.hasData(_key);
  }
}
