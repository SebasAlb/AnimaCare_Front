import 'package:get/get.dart';

class MedicalHistoryController extends GetxController {
  var petName = 'Nombre Mascota'.obs;
  var vaccines = 'Vacuna de la rabia aplicada.'.obs;
  var dewormings = 'Última desparasitación hace 3 meses.'.obs;

  void updateVaccines(String newValue) {
    vaccines.value = newValue;
  }

  void updateDewormings(String newValue) {
    dewormings.value = newValue;
  }
}
