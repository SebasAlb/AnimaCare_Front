import 'package:animacare_front/presentation/screens/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    final ThemeData theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          controller.goBack();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton.icon(
                      onPressed: controller.goBack,
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        'Volver',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Crear Cuenta',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    label: 'Nombre',
                    hint: 'Ingrese su nombre',
                    icon: Icons.person,
                    controller: controller.firstNameController,
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Apellido',
                    hint: 'Ingrese su apellido',
                    icon: Icons.person_outline,
                    controller: controller.lastNameController,
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Cédula',
                    hint: 'Ingrese su cédula',
                    icon: Icons.badge,
                    controller: controller.cedulaController,
                    theme: theme,
                    type: TextInputType.number, // Teclado numérico
                  ),


                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Correo Electrónico',
                    hint: 'Ingrese su correo electrónico',
                    icon: Icons.email,
                    controller: controller.emailController,
                    type: TextInputType.emailAddress,
                    theme: theme,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => _buildTextField(
                    label: 'Contraseña',
                    hint: 'Ingrese una contraseña segura',
                    icon: Icons.lock,
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    theme: theme,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
                  const SizedBox(height: 20),
                  Obx(() => _buildTextField(
                    label: 'Confirmar Contraseña',
                    hint: 'Confirme su contraseña',
                    icon: Icons.lock_outline,
                    controller: controller.confirmPasswordController,
                    obscureText: controller.obscureConfirmPassword.value,
                    theme: theme,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  )),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.signup,
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
    required String label,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscureText = false,
    required TextEditingController controller,
    required ThemeData theme,
    Widget? suffixIcon,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: type,
            obscureText: obscureText,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
              theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              prefixIcon: Icon(icon, color: theme.colorScheme.primary),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
}

