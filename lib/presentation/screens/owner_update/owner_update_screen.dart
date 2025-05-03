import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'owner_update_controller.dart';
import 'package:animacare_front/presentation/theme/colors.dart';

class UserOwnerScreen extends StatelessWidget {
  const UserOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OwnerUpdateController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded( // 🔥 Solución: usar Expanded para que lo que viene abajo pueda scrollar y no desborde
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.cardBackground,
                      child: Icon(Icons.person, size: 80, color: AppColors.header),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      label: 'Nombre',
                      hint: 'Ingrese su nombre',
                      controller: controller.nameController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Apellido',
                      hint: 'Ingrese su apellido',
                      controller: controller.lastNameController,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Correo Electrónico',
                      hint: 'Ingrese su correo electrónico',
                      controller: controller.emailController,
                      icon: Icons.email,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de cambiar contraseña aún no implementada'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cambiar Contraseña',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.header,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.saveUserInfo,
                      child: const Text(
                        'Guardar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.calendar);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }

  Future<bool> _confirmarSalida(BuildContext context, OwnerUpdateController controller) async {
    final hayCambios = controller.nameController.text.isNotEmpty ||
        controller.lastNameController.text.isNotEmpty ||
        controller.emailController.text.isNotEmpty;

    if (hayCambios) {
      final salir = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¿Descartar cambios?'),
          content: const Text('Tienes cambios sin guardar. ¿Seguro que quieres salir?'),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir'),
            ),
          ],
        ),
      );
      return salir ?? false;
    }

    return true;
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.header),
            filled: true,
            fillColor: const Color(0xFFF0F4F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
