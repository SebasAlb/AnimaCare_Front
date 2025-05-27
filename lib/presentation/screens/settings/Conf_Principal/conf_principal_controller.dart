import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/storage/user_storage.dart';

class ConfPrincipalController extends GetxController {
  void onTapSetting(BuildContext context, String title) {
    switch (title) {
      case 'Mi perfil':
        Get.toNamed('/settings/editProfile');
        break;
      case 'Cerrar sesión':
        // NO ELIMINAR el ThemeController aquí.
        // En su lugar, encontrar la instancia existente (puesta permanentemente al inicio)
        // y usar su método para cambiar el tema a claro.
        // toggleTheme(false) ya se encarga de actualizar el storage y llamar a update().

        if (Get.isRegistered<ThemeController>()) {
          // Encontrar la instancia y llamarle al método para poner el tema claro
          Get.find<ThemeController>().toggleTheme(false); // false = modo claro
        } else {
          // Este caso no debería ocurrir si el controlador se puso permanentemente al inicio.
          // Podrías añadir un log o manejo de error si es necesario.
          debugPrint(
            'ThemeController no encontrado durante el cierre de sesión. No se pudo resetear el tema via controlador.',
          );
          // Opcional: Forzar el almacenamiento a false como fallback si el controlador no está
          // final _storage = GetStorage();
          // _storage.write('isDarkMode', false);
        }
        UserStorage.clearUser();
        Get.offAllNamed('/login');
        break;
      case 'Notificaciones':
        Get.toNamed('/edit_notifications');
        break;
      case 'Recordatorios':
      case 'Idioma':
      case 'Tema oscuro':
        // TODO: navegación futura o alertas
        break;
    }
  }
}
