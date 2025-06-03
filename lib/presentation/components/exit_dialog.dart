import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ExitDialog {
  static Future<bool> show() async =>
      await Get.dialog(
        AlertDialog(
          title: const Text('¿Salir de la aplicación?', style: TextStyle(color: Colors.black),),
          content: const Text('¿Estás seguro que deseas salir?', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                SoundService.playButton();
                Get.back(result: false);
              }, // Cancelar
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
