import 'package:animacare_front/presentation/screens/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    final ThemeData theme = Theme.of(context);

    return Obx(() => Stack(
      children: [
        PopScope(
          canPop: !controller.isLoading.value,
          onPopInvoked: (didPop) async {
            if (!didPop && !controller.isLoading.value) {
              controller.goBack();
            }
          },
          child: AbsorbPointer(
            absorbing: controller.isLoading.value,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildForm(context, controller, theme),
                ),
              ),
            ),
          ),
        ),
        if (controller.isLoading.value) _buildLoadingOverlay(theme),
      ],
    ));
  }

  Widget _buildForm(BuildContext context, SignupController controller, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              onPressed: controller.goBack,
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
              label: Text('Volver', style: TextStyle(color: theme.colorScheme.primary)),
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
          _buildTextField('Nombre', 'Ingrese su nombre', Icons.person, controller.firstNameController, theme),
          const SizedBox(height: 20),
          _buildTextField('Apellido', 'Ingrese su apellido', Icons.person_outline, controller.lastNameController, theme),
          const SizedBox(height: 20),
          _buildTextField('Cédula', 'Ingrese su cédula', Icons.badge, controller.cedulaController, theme, TextInputType.number),
          const SizedBox(height: 20),
          _buildTextField('Correo Electrónico', 'Ingrese su correo', Icons.email, controller.emailController, theme, TextInputType.emailAddress),
          const SizedBox(height: 20),
          Obx(() => _buildTextField(
            'Contraseña',
            'Ingrese una contraseña segura',
            Icons.lock,
            controller.passwordController,
            theme,
            TextInputType.text,
            controller.obscurePassword.value,
            IconButton(
              icon: Icon(controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility, color: theme.colorScheme.primary),
              onPressed: controller.togglePasswordVisibility,
            ),
          )),
          const SizedBox(height: 20),
          Obx(() => _buildTextField(
            'Confirmar Contraseña',
            'Confirme su contraseña',
            Icons.lock_outline,
            controller.confirmPasswordController,
            theme,
            TextInputType.text,
            controller.obscureConfirmPassword.value,
            IconButton(
              icon: Icon(controller.obscureConfirmPassword.value ? Icons.visibility_off : Icons.visibility, color: theme.colorScheme.primary),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
          )),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: controller.signup,
            child: const Text('Registrarse', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller,
      ThemeData theme, [
        TextInputType type = TextInputType.text,
        bool obscureText = false,
        Widget? suffixIcon,
      ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscureText,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            prefixIcon: Icon(icon, color: theme.colorScheme.primary),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay(ThemeData theme) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 300,
                  width: 300,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/animacion_cargando.gif',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
