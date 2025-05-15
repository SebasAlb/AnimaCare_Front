import 'dart:io';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditarPerfilScreen extends StatelessWidget {
  const EditarPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditarPerfilController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              nameScreen: "Editar Perfil",
              isSecondaryScreen: true,
            ),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: theme.cardColor,
                          backgroundImage: controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                              : null,
                          child: controller.selectedImage.value == null
                              ? Icon(Icons.camera_alt,
                              color: theme.colorScheme.primary, size: 30)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField('Nombre', 'Ingrese su nombre', Icons.person,
                        controller.nombreController, theme),
                    _buildTextField('Apellido', 'Ingrese su apellido',
                        Icons.person_outline, controller.apellidoController, theme),
                    _buildTextField('Cédula', 'Ingrese su número de cédula',
                        Icons.credit_card, controller.cedulaController, theme),
                    _buildTextField('Teléfono', 'Ingrese su número', Icons.phone,
                        controller.telefonoController, theme, type: TextInputType.phone),
                    _buildTextField(
                        'Correo Electrónico',
                        'Ingrese su correo',
                        Icons.email,
                        controller.correoController,
                        theme,
                        type: TextInputType.emailAddress),
                    _buildTextField('Ciudad', 'Ingrese su ciudad',
                        Icons.location_city, controller.ciudadController, theme),
                    _buildTextField('Dirección', 'Ingrese su dirección', Icons.home,
                        controller.direccionController, theme),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => controller.abrirCambiarContrasena(context),
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
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: controller.onGuardar,
                      child: const Text('Guardar',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              )),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              )),
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
