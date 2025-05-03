import 'package:get/get.dart';

class RecommendationsController extends GetxController {
  final RxString petName = 'Gato 1'.obs;
  final RxString petType = 'Gato'.obs;
  final RxString petGender = 'Hembra'.obs;
  final RxString petBreed = 'Persa'.obs;
  final RxString petAge = '3 años'.obs;

  final RxList<String> recommendations = <String>[
    'Este es un ejemplo de mascota en el listado ......',
    'Recuerda cepillar su pelaje frecuentemente.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
    'Visita al veterinario cada 6 meses.',
  ].obs;
}
