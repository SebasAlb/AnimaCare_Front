import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEventController extends GetxController {
  final RxString nombreEvento = ''.obs;
  final RxString mascotaSeleccionada = ''.obs;
  final RxString tipoLugar = 'manual'.obs;
  final RxString lugarEvento = ''.obs;
  final RxString veterinariaSeleccionada = ''.obs;
  final Rxn<DateTime> fechaEvento = Rxn<DateTime>(); // Puede ser nulo
  final Rxn<TimeOfDay> horaEvento = Rxn<TimeOfDay>(); // Puede ser nulo
  final RxString categoriaEvento = ''.obs;

  final RxList<String> categorias = <String>['Baño', 'Veterinario', 'Medicina', 'Vacuna'].obs;
  final RxList<String> veterinarias =
      <String>['Veterinaria Paws', 'Centro AnimalCare', 'PetClinic Plus'].obs;
  final RxList<String> mascotas = <String>['Firulais', 'Mishi', 'Kira', 'Luna'].obs;

  final RxString anticipacion = '1 día antes'.obs;
  final RxString frecuencia = 'Cada 6 horas'.obs;
  final RxString recibirRecordatorio = 'Solo en la app'.obs;

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
