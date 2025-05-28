import 'dart:io';
import 'package:animacare_front/services/owner_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:dio/dio.dart' as dio;


class EditarPerfilController extends GetxController {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  final Rxn<File> selectedImage = Rxn<File>();
  String? fotoUrl;

  static const String cloudName = 'debn6u09z';
  static const String uploadPreset = 'ml_default';

  @override
  void onInit() {
    super.onInit();
    final Dueno? user = UserStorage.getUser();
    if (user != null) {
      nombreController.text = user.nombre;
      apellidoController.text = user.apellido;
      cedulaController.text = user.cedula;
      telefonoController.text = user.telefono!;
      correoController.text = user.correo;
      ciudadController.text = user.ciudad!;
      direccionController.text = user.direccion!;
      fotoUrl = user.fotoUrl;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      final ext = image.path.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(ext)) {
        Get.snackbar(
          'Archivo no válido',
          'Solo se permiten imágenes JPG, JPEG, PNG o WebP',
          backgroundColor: Colors.white,
          colorText: Colors.red,
        );
        return;
      }

      selectedImage.value = File(image.path);
    }
  }

  Future<String?> uploadToCloudinary(File file) async {
    final dioClient = dio.Dio();
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(file.path),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await dioClient.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        final url = response.data['secure_url'];
        print('[Cloudinary] Imagen subida: $url');
        return url;
      } else {
        print('[Cloudinary] Código inesperado: ${response.statusCode}');
        Get.snackbar('Error', 'Error al subir imagen: ${response.statusMessage}');
        return null;
      }
    } on dio.DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      print('[Cloudinary] Error Dio: $msg');
      Get.snackbar('Error', 'Error al subir imagen: $msg');
      return null;
    } catch (e) {
      print('[Cloudinary] Error general: $e');
      Get.snackbar('Error', 'Error inesperado al subir imagen.');
      return null;
    }
  }

  void onGuardar() async {
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

    String? imageUrl = fotoUrl;
    if (selectedImage.value != null) {
      final result = await uploadToCloudinary(selectedImage.value!);
      if (result == null) {
        return;
      }
      imageUrl = result;
    }

    final Dueno updatedUser = Dueno(
      id: UserStorage.getUser()!.id,
      nombre: nombreController.text.trim(),
      apellido: apellidoController.text.trim(),
      cedula: cedulaController.text.trim(),
      telefono: telefonoController.text.trim(),
      correo: correoController.text.trim(),
      ciudad: ciudadController.text.trim(),
      direccion: direccionController.text.trim(),
      contrasena: UserStorage.getUser()!.contrasena,
      fotoUrl: imageUrl ?? '',
    );

    try {
      final Dueno? response = await OwnerService().actualizarDueno(updatedUser);

      if (response != null) {
        UserStorage.updateUser(response);
        Get.snackbar(
          'Perfil actualizado',
          'Tus datos se guardaron correctamente.',
          backgroundColor: Colors.white,
          colorText: Colors.black,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        Get.offAllNamed('/settings');
      } else {
        throw Exception('Respuesta nula');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al actualizar perfil: ${e.toString()}',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
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
                const Text(
                  'Cambiar Contraseña',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => _passwordInput(
                    'Contraseña Actual',
                    actual,
                    visibleActual,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => _passwordInput('Nueva Contraseña', nueva, visibleNueva),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => _passwordInput(
                    'Confirmar Contraseña',
                    confirmar,
                    visibleConfirmar,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nueva.text != confirmar.text) {
                        Get.snackbar(
                          'Error',
                          'Las contraseñas no coinciden.',
                          backgroundColor: Colors.white,
                          colorText: Colors.red,
                        );
                        return;
                      }
                      Get.back();
                      Get.snackbar(
                        'Éxito',
                        'Contraseña cambiada correctamente.',
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF301B92),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
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
    String label,
    TextEditingController controller,
    RxBool visible,
  ) =>
      TextField(
        controller: controller,
        obscureText: !visible.value,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: const Color(0xFFF0F4F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              visible.value ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => visible.value = !visible.value,
          ),
        ),
      );

  void resetearEstado() {
    nombreController.clear();
    apellidoController.clear();
    cedulaController.clear();
    telefonoController.clear();
    correoController.clear();
    ciudadController.clear();
    direccionController.clear();
    selectedImage.value = null;
    fotoUrl = null;
  }

  @override
  void onClose() {
    resetearEstado();
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
