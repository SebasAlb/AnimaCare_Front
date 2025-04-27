import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddEventController extends GetxController {
  // Campos
  final nombreEvento = ''.obs;
  final mascotaSeleccionada = 'Firulais'.obs;
  final tipoLugar = 'manual'.obs; // 'manual' o 'veterinaria'
  final lugarEvento = ''.obs;
  final veterinariaSeleccionada = ''.obs;

  final fechaEvento = DateTime.now().obs;
  final horaEvento = TimeOfDay.now().obs;
  final categoriaEvento = 'Baño'.obs;

  // Opciones
  final categorias = ['Baño', 'Veterinario', 'Medicina', 'Vacuna'].obs;
  final veterinarias = ['Veterinaria Paws', 'Centro AnimalCare', 'PetClinic Plus'].obs;
  final mascotas = ['Firulais', 'Mishi', 'Kira', 'Luna'].obs;

  void resetForm() {
    nombreEvento.value = '';
    tipoLugar.value = 'manual';
    lugarEvento.value = '';
    veterinariaSeleccionada.value = '';
    fechaEvento.value = DateTime.now();
    horaEvento.value = TimeOfDay.now();
    categoriaEvento.value = 'Baño';
  }
}