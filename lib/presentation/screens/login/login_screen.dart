import 'package:animacare_front/presentation/components/exit_dialog.dart';
import 'package:animacare_front/presentation/screens/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final bool shouldExit = await ExitDialog.show();
          if (shouldExit) {
            // Si decides salir, puedes cerrar la app o ir a una pantalla anterior
            // Depende de tu flujo de salida. Get.back() podría no funcionar aquí si es la primera pantalla.
            // exit(0); // Considera usar esto o un plugin si Get.back no funciona como esperas en Android nativo
            // O quizás SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Inicio de Sesión',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      'https://via.placeholder.com/300x200',
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: size.height * 0.2,
                        width: size.width * 0.4,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.image_not_supported, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    context: context,
                    label: 'Correo Electrónico',
                    hint: 'Ingrese su correo electrónico',
                    icon: Icons.person,
                    type: TextInputType.emailAddress,
                    controller: controller.emailController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context: context,
                    label: 'Contraseña',
                    hint: 'Ingrese su contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: controller.passwordController,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.login,
                    child: Text(
                      'Ingresar',
                      style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: controller.goToRegister,
                    child: Text(
                      'Registrarse',
                      style: TextStyle(
                          color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: theme.colorScheme.primary),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
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