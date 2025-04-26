import 'package:get/get.dart';

class RecommendationsController extends GetxController {
  final petName = 'Gato 1'.obs;
  final petType = 'Gato'.obs;
  final petGender = 'Hembra'.obs;
  final petBreed = 'Persa'.obs;
  final petAge = '3 años'.obs;

  final recommendations = <String>[
    'Este es un ejemplo de mascota en el listado ......',
    'Recuerda cepillar su pelaje frecuentemente.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
  ].obs;
}
