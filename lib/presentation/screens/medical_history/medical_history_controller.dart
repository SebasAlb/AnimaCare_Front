import 'package:get/get.dart';

class MedicalHistoryController extends GetxController {
  RxString petName = 'Nombre Mascota'.obs;
  RxString vaccines = 'Vacuna de la rabia aplicada.'.obs;
  RxString dewormings = 'Última desparasitación hace 3 meses.'.obs;

  void updateVaccines(String newValue) {
    vaccines.value = newValue;
  }

  void updateDewormings(String newValue) {
    dewormings.value = newValue;
  }
}
