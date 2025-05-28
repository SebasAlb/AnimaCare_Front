import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_controller.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditarPerfilScreen extends StatelessWidget {
  const EditarPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditarPerfilController controller = Get.find();
    final ThemeData theme = Theme.of(context);

      return WillPopScope(
        onWillPop: () async {
          // ⬇️ Si NO hay cambios pendientes se sale directo
          if (!controller.hasChanges.value) return true;
          SoundService.playButton();
          final res = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('¿Seguro que desea salir?'),
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Si sales ahora perderás los cambios realizados.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Si'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: null),
                  child: const Text('No'),
                ),
              ],
            ),
            barrierDismissible: false,
          );

          // true  => ya guardó; allow pop
          // false => salir sin guardar; allow pop
          // null  => canceló; stay
          return res != null;
        },

        child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: <Widget>[
                  const CustomHeader(
                    nameScreen: 'Editar Perfil',
                    isSecondaryScreen: true,
                  ),
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: GestureDetector(
                                onTap: controller.pickImage,
                                child: controller.selectedImage.value != null
                                    ? CircleAvatar(
                                  radius: 45,
                                  backgroundImage: FileImage(controller.selectedImage.value!),
                                )
                                    : controller.fotoUrl != null && controller.fotoUrl!.isNotEmpty
                                    ? CircleAvatar(
                                  radius: 45,
                                  backgroundImage: NetworkImage(controller.fotoUrl!),
                                )
                                    : CircleAvatar(
                                  radius: 45,
                                  backgroundColor: theme.cardColor,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: theme.colorScheme.primary,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildTextField(
                              'Nombre',
                              'Ingrese su nombre',
                              Icons.person,
                              controller.nombreController,
                              theme,
                            ),
                            _buildTextField(
                              'Apellido',
                              'Ingrese su apellido',
                              Icons.person_outline,
                              controller.apellidoController,
                              theme,
                            ),
                            _buildTextField(
                              'Cédula',
                              'Ingrese su número de cédula',
                              Icons.credit_card,
                              controller.cedulaController,
                              theme,
                            ),
                            _buildTextField(
                              'Teléfono',
                              'Ingrese su número',
                              Icons.phone,
                              controller.telefonoController,
                              theme,
                              type: TextInputType.phone,
                            ),
                            _buildTextField(
                              'Correo Electrónico',
                              'Ingrese su correo',
                              Icons.email,
                              controller.correoController,
                              theme,
                              type: TextInputType.emailAddress,
                            ),
                            _buildTextField(
                              'Ciudad',
                              'Ingrese su ciudad',
                              Icons.location_city,
                              controller.ciudadController,
                              theme,
                            ),
                            _buildTextField(
                              'Dirección',
                              'Ingrese su dirección',
                              Icons.home,
                              controller.direccionController,
                              theme,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () =>
                                    controller.abrirCambiarContrasena(context),
                                child: const Text(
                                  'Cambiar Contraseña',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                SoundService.playButton();
                                controller.onGuardar();
                              },
                              child: const Text(
                                'Guardar',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => controller.isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
                : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller,
      ThemeData theme, {
        TextInputType type = TextInputType.text,
      }) {
    final isRequired = ['Nombre', 'Apellido', 'Cédula', 'Correo Electrónico'].contains(label);
    final isEmpty = controller.text.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label${isRequired ? ' *' : ''}',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: type,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
              prefixIcon: Icon(icon, color: theme.colorScheme.primary),
              filled: true,
              fillColor: theme.cardColor,
              errorText: isRequired && isEmpty ? 'Este campo es obligatorio' : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
