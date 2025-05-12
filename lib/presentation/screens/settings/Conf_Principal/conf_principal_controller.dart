import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfPrincipalController extends GetxController {
  void onTapSetting(BuildContext context, String title) {
    switch (title) {
      case 'Mi perfil':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditarPerfilScreen()),
        );
        break;
      case 'Cerrar sesión':
        break;
      case 'Notificaciones':
        Get.toNamed('/edit_notifications');
        break;
      case 'Recordatorios':
      case 'Idioma':
      case 'Tema oscuro':
      case 'Política de privacidad':
      case 'Compartir con veterinario':
      case 'Ayuda y soporte':
        // TODO: navegación futura o alertas
        break;
    }
  }
}
