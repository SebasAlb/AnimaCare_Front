import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:animacare_front/storage/pet_storage.dart';
import 'package:animacare_front/storage/veterinarian_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/storage/user_storage.dart';

class ConfPrincipalController extends GetxController {
  void onTapSetting(BuildContext context, String title) {
    switch (title) {
      case 'Mi perfil':
        SoundService.playButton();
        Get.toNamed('/settings/editProfile');
        break;
      case 'Cerrar sesión':
        SoundService.playButton();
        if (Get.isRegistered<ThemeController>()) {
          Get.find<ThemeController>().toggleTheme(false);
        } else {
          debugPrint(
            'ThemeController no encontrado durante el cierre de sesión. No se pudo resetear el tema via controlador.',
          );
        }
        UserStorage.clearUser();
        MascotasStorage.clearMascotas();
        VeterinariosStorage.clearVeterinarios();
        Get.offAllNamed('/login');
        break;
      case 'Notificaciones':
        Get.toNamed('/edit_notifications');
        break;
    }
  }
}
