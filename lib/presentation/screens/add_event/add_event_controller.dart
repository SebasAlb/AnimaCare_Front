import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddEventController extends GetxController {
  final nombreEvento = ''.obs;
  final mascotaSeleccionada = ''.obs;
  final tipoLugar = 'manual'.obs;
  final lugarEvento = ''.obs;
  final veterinariaSeleccionada = ''.obs;
  final fechaEvento = Rxn<DateTime>(); // Puede ser nulo
  final horaEvento = Rxn<TimeOfDay>(); // Puede ser nulo
  final categoriaEvento = ''.obs;

  final categorias = ['Baño', 'Veterinario', 'Medicina', 'Vacuna'].obs;
  final veterinarias = ['Veterinaria Paws', 'Centro AnimalCare', 'PetClinic Plus'].obs;
  final mascotas = ['Firulais', 'Mishi', 'Kira', 'Luna'].obs;

  void resetForm() {
    nombreEvento.value = '';
    tipoLugar.value = 'manual';
    lugarEvento.value = '';
    veterinariaSeleccionada.value = '';
    fechaEvento.value = null;
    horaEvento.value = null;
    categoriaEvento.value = '';
    mascotaSeleccionada.value = '';
  }
}
