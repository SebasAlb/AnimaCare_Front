import 'dart:io';
import 'package:animacare_front/services/auth_service.dart';
import 'package:animacare_front/services/owner_service.dart';
import 'package:animacare_front/services/sound_service.dart';
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
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;
  final Rxn<File> selectedImage = Rxn<File>();
  String? fotoUrl;

  static const String cloudName = 'debn6u09z';
  static const String uploadPreset = 'ml_default';
  final theme = Theme.of(Get.context!);

  late Dueno _initial;
  final hasChanges = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initial = UserStorage.getUser()!;
    final u = _initial;
    nombreController..text = u.nombre   ..addListener(_markChanged);
    apellidoController..text = u.apellido..addListener(_markChanged);
    cedulaController..text = u.cedula   ..addListener(_markChanged);
    telefonoController..text = u.telefono ?? '' ..addListener(_markChanged);
    correoController..text = u.correo   ..addListener(_markChanged);
    ciudadController..text = u.ciudad ?? ''     ..addListener(_markChanged);
    direccionController..text = u.direccion ?? '' ..addListener(_markChanged);
    fotoUrl = u.fotoUrl;
  }
  void _markChanged() => hasChanges.value = true;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      final ext = image.path.split('.').last.toLowerCase();

      if (!allowedExtensions.contains(ext)) {
        SoundService.playWarning();
        Get.snackbar(
          'Archivo no válido',
          'Solo se permiten imágenes JPG, JPEG, PNG o WebP',
          backgroundColor: Colors.white30,
          colorText: theme.colorScheme.onBackground,
          icon: const Icon(Icons.warning, color: Colors.redAccent),
        );
        return;
      }

      selectedImage.value = File(image.path);
      hasChanges.value = true;
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
        SoundService.playWarning();
        Get.snackbar(
          'Error al subir imagen',
          'Respuesta inesperada: ${response.statusMessage}',
          backgroundColor: Colors.white30,
          colorText: theme.colorScheme.onBackground,
          icon: const Icon(Icons.warning, color: Colors.redAccent),
        );
        return null;
      }
    } on dio.DioException catch (e) {
      final msg = e.response?.data ?? e.message;
      print('[Cloudinary] Error Dio: $msg');
      final theme = Theme.of(Get.context!);
      SoundService.playWarning();
      Get.snackbar(
        'Error al subir imagen',
        '$msg',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return null;
    } catch (e) {
      print('[Cloudinary] Error general: $e');
      final theme = Theme.of(Get.context!);
      SoundService.playWarning();
      Get.snackbar(
        'Error inesperado',
        'No se pudo subir la imagen.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return null;
    }
  }

  bool validarCamposObligatorios() {
    final nombre = nombreController.text.trim();
    final apellido = apellidoController.text.trim();
    final cedula = cedulaController.text.trim();
    final correo = correoController.text.trim();
    final direccion = direccionController.text.trim();

    final List<String> errores = [];

    if (nombre.isEmpty) errores.add('Nombre');
    if (apellido.isEmpty) errores.add('Apellido');
    if (cedula.isEmpty) errores.add('Cédula');
    if (correo.isEmpty) errores.add('Correo');

    if (errores.isNotEmpty) {
      final theme = Theme.of(Get.context!);
      SoundService.playWarning();
      Get.snackbar(
        'Campos requeridos',
        'Debe completar: ${errores.join(', ')}.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return false;
    }

    // Validaciones específicas
    if (nombre.length > 60) {
      _mostrarError('Nombre no debe superar los 60 caracteres.');
      return false;
    }

    if (apellido.length > 60) {
      _mostrarError('Apellido no debe superar los 60 caracteres.');
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(cedula)) {
      _mostrarError('La cédula debe tener exactamente 10 dígitos numéricos.');
      return false;
    }

    if (!correo.contains('@')) {
      _mostrarError('El correo debe contener el carácter "@".');
      return false;
    }

    if (direccion.length > 150) {
      _mostrarError('La dirección no debe superar los 150 caracteres.');
      return false;
    }

    return true;
  }

  void _mostrarError(String mensaje) {
    SoundService.playWarning();
    Get.snackbar(
      'Validación',
      mensaje,
      backgroundColor: Colors.white30,
      colorText: theme.colorScheme.onBackground,
      icon: const Icon(Icons.warning, color: Colors.redAccent),
    );
  }

  Future<void> onGuardar() async {
    if (!validarCamposObligatorios()) return;
    isLoading.value = true;

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
        _initial = response;                // ← estado base actualizado
        hasChanges.value = false;           // ya no hay cambios pendientes
        selectedImage.value = null;
        UserStorage.updateUser(response);
        Get.snackbar(
          'Perfil actualizado',
          'Tus datos se guardaron correctamente.',
          backgroundColor: Colors.white30,
          colorText: theme.colorScheme.onBackground,
          icon: const Icon(Icons.check_circle, color: Colors.green),
        );
        Get.offAllNamed('/settings');
        SoundService.playSuccess();
      } else {
        throw Exception('Respuesta nula');
      }
    } catch (e) {
      SoundService.playWarning();
      Get.snackbar(
        'Error',
        'Error al actualizar perfil: ${e.toString()}',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void abrirCambiarContrasena(BuildContext context) {
    SoundService.playButton();
    final theme = Theme.of(context);
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
        builder: (context, scrollController) => WillPopScope(
          onWillPop: () async => !isLoading.value,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Cambiar Contraseña',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() => _passwordInput('Contraseña Actual', actual, visibleActual, theme)),
                  const SizedBox(height: 12),
                  Obx(() => _passwordInput('Nueva Contraseña', nueva, visibleNueva, theme)),
                  const SizedBox(height: 12),
                  Obx(() => _passwordInput('Confirmar Contraseña', confirmar, visibleConfirmar, theme)),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nueva.text.trim() != confirmar.text.trim()) {
                          cerrarDialogoDeCarga();
                          SoundService.playWarning();
                          Get.snackbar(
                            'Error',
                            'Las contraseñas no coinciden.',
                            backgroundColor: Colors.white30,
                            colorText: theme.colorScheme.onBackground,
                            icon: const Icon(Icons.warning, color: Colors.redAccent),
                          );
                          return;
                        }

                        if (actual.text.trim().isEmpty || nueva.text.trim().isEmpty || confirmar.text.trim().isEmpty) {
                          cerrarDialogoDeCarga();
                          SoundService.playWarning();
                          Get.snackbar(
                            'Campos requeridos',
                            'Debe completar todos los campos.',
                            backgroundColor: Colors.white30,
                            colorText: theme.colorScheme.onBackground,
                            icon: const Icon(Icons.warning, color: Colors.redAccent),
                          );
                          return;
                        }

                        Get.dialog(
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                          barrierDismissible: false,
                        );

                        try {
                          final response = await _authService.changePassword(
                            userId: UserStorage.getUser()!.id,
                            contrasenaActual: actual.text.trim(),
                            nuevaContrasena: nueva.text.trim(),
                          );
                          print("////" + response.toString());
                          if (response != null) {
                            cerrarDialogoDeCarga();
                            Get.back(); // Cierra el diálogo de carga
                            Get.back(); // Cierra el bottom sheet
                            Get.snackbar(
                              'Éxito',
                              '${response}',
                              backgroundColor: Colors.white30,
                              colorText: theme.colorScheme.onBackground,
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                            );
                            SoundService.playSuccess();
                          }
                        } catch (e) {
                          cerrarDialogoDeCarga();
                          SoundService.playWarning();
                          Get.snackbar(
                            'Error',
                            e.toString().replaceAll('Exception: ', ''),
                            backgroundColor: Colors.white30,
                            colorText: theme.colorScheme.onBackground,
                            icon: const Icon(Icons.warning, color: Colors.redAccent),
                          );
                        } finally {
                          cerrarDialogoDeCarga();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
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
      ),
      isDismissible: false,
      enableDrag: false,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _passwordInput(
      String label,
      TextEditingController controller,
      RxBool visible,
      ThemeData theme,
      ) =>
      TextField(
        controller: controller,
        obscureText: !visible.value,
        style: theme.textTheme.labelMedium,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.labelMedium,
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              visible.value ? Icons.visibility_off : Icons.visibility,
              color: theme.iconTheme.color,
            ),
            onPressed: () => {
              visible.value = !visible.value,
              SoundService.playButton()
            }
          ),
        ),
      );

  void cerrarDialogoDeCarga() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

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
