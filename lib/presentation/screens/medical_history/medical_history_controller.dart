import 'package:get/get.dart';

class MedicalHistoryController extends GetxController {
  RxString petName = 'Gato 1'.obs;

  RxList<String> vaccines = <String>[
    'Vacuna de la rabia aplicada.',
    'Vacuna pentavalente aplicada.',
  ].obs;

  RxList<String> dewormings = <String>[
    'Desparasitación interna - Febrero',
    'Desparasitación externa - Marzo',
  ].obs;
}
