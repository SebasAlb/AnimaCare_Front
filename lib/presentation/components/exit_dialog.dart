import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esto para cerrar la app
import 'package:get/get.dart';

class ExitDialog {
  static Future<bool> show() async =>
      await Get.dialog(
        AlertDialog(
          title: const Text('¿Salir de la aplicación?'),
          content: const Text('¿Estás seguro que deseas salir?'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(result: false), // Cancelar
              child: const Text('Cancelar'),
            ),
            const TextButton(
              onPressed: SystemNavigator.pop,
              child: Text('Salir'),
            ),
          ],
        ),
        barrierDismissible: false,
      ) ??
      false;
}
