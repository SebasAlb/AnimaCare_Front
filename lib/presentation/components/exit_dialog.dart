import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'; // Importa esto para cerrar la app

class ExitDialog {
  static Future<bool> show() async {
    return await Get.dialog(
      AlertDialog(
        title: const Text('¿Salir de la aplicación?'),
        content: const Text('¿Estás seguro que deseas salir?'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false), // Cancelar
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Salir de la app
              SystemNavigator.pop();
            },
            child: const Text('Salir'),
          ),
        ],
      ),
      barrierDismissible: false,
    ) ?? false;
  }
}
