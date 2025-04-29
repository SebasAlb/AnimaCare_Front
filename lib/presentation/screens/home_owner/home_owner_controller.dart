import 'package:get/get.dart';

class HomeOwnerController extends GetxController {
  // Aquí puedes tener las mascotas cargadas desde tu API o servicio
  var pets = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  void loadPets() {
    pets.value = [
      {'name': 'Gato 1', 'description': 'Este es un ejemplo de mascota en el listado'},
      {'name': 'Gato 2', 'description': 'Otro gato feliz registrado'},
      {'name': 'Perro 1', 'description': 'Un perro muy juguetón'},
    ];
  }

  void addPet() {
    // Aquí puedes navegar a una pantalla de agregar mascota
    Get.snackbar('Añadir Mascota', 'Funcionalidad no implementada aún.');
  }

  void editProfile() {
    // Navegar a editar perfil
    Get.snackbar('Editar Perfil', 'Funcionalidad no implementada aún.');
  }

  void goToDetailsPet(){
    Get.toNamed('/recommendations');
  }
}
