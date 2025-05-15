import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditarPerfilController extends GetxController {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  final Rxn<File> selectedImage = Rxn<File>();

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void onGuardar() {
    if (nombreController.text.isEmpty || correoController.text.isEmpty) {
      Get.snackbar(
        'Campos requeridos',
        'Nombre y correo electrónico son obligatorios.',
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    // Simular llamada al API
    Future.delayed(const Duration(seconds: 1), () {
      Get.snackbar(
        'Perfil actualizado',
        'Tus datos se guardaron correctamente.',
        backgroundColor: Colors.white,
        colorText: Colors.black,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    });
  }

  void abrirCambiarContrasena(BuildContext context) {
    final TextEditingController actual = TextEditingController();
    final TextEditingController nueva = TextEditingController();
    final TextEditingController confirmar = TextEditingController();
    final RxBool visibleActual = false.obs;
    final RxBool visibleNueva = false.obs;
    final RxBool visibleConfirmar = false.obs;

    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Cambiar Contraseña',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                const SizedBox(height: 20),
                Obx(() =>
                    _passwordInput('Contraseña Actual', actual, visibleActual),),
                const SizedBox(height: 12),
                Obx(() =>
                    _passwordInput('Nueva Contraseña', nueva, visibleNueva),),
                const SizedBox(height: 12),
                Obx(() => _passwordInput(
                    'Confirmar Contraseña', confirmar, visibleConfirmar,),),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nueva.text != confirmar.text) {
                        Get.snackbar('Error', 'Las contraseñas no coinciden.',
                            backgroundColor: Colors.white,
                            colorText: Colors.red,);
                        return;
                      }
                      Get.back();
                      Get.snackbar(
                          'Éxito', 'Contraseña cambiada correctamente.',
                          backgroundColor: Colors.white,
                          colorText: Colors.black,);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF301B92),),
                    child: const Text('Guardar',
                        style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordInput(
      String label, TextEditingController controller, RxBool visible,) => TextField(
      controller: controller,
      obscureText: !visible.value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,),
        suffixIcon: IconButton(
          icon: Icon(visible.value ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,),
          onPressed: () => visible.value = !visible.value,
        ),
      ),
    );

  @override
  void onClose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    ciudadController.dispose();
    direccionController.dispose();
    super.onClose();
  }
}
