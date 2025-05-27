import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/models/dueno.dart';

class UserStorage {
  static final GetStorage _box = GetStorage();
  static const String _key = 'user_data';

  static void saveUser(Dueno user) {
    _box.write(_key, user.toJson());
  }

  static Dueno? getUser() {
    final data = _box.read(_key);
    return data != null ? Dueno.fromJson(Map<String, dynamic>.from(data)) : null;
  }

  static void updateUser(Dueno updatedUser) {
    // Reescribe todos los campos actualizados
    _box.write(_key, updatedUser.toJson());
  }

  static void clearUser() {
    _box.remove(_key);
  }

  static bool isLoggedIn() {
    return _box.hasData(_key);
  }
}
