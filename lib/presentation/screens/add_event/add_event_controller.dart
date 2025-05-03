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
  final veterinarias =
      ['Veterinaria Paws', 'Centro AnimalCare', 'PetClinic Plus'].obs;
  final mascotas = ['Firulais', 'Mishi', 'Kira', 'Luna'].obs;

  final anticipacion = '1 día antes'.obs;
  final frecuencia = 'Cada 6 horas'.obs;
  final recibirRecordatorio = 'Solo en la app'.obs;

  void resetForm() {
    nombreEvento.value = '';
    tipoLugar.value = 'manual';
    lugarEvento.value = '';
    veterinariaSeleccionada.value = '';
    fechaEvento.value = null;
    horaEvento.value = null;
    categoriaEvento.value = '';
    mascotaSeleccionada.value = '';
    anticipacion.value = '1 día antes';
    frecuencia.value = 'Cada 6 horas';
    recibirRecordatorio.value = 'Solo en la app';
  }
}
