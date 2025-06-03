import 'package:animacare_front/presentation/components/exit_dialog.dart';
import 'package:animacare_front/presentation/screens/login/login_controller.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Obx(() => Stack(
      children: [
        PopScope(
          canPop: !controller.isLoading.value,
          onPopInvoked: (didPop) async {
            if (!didPop && !controller.isLoading.value) {
              final bool shouldExit = await ExitDialog.show();
              if (shouldExit) {
                Get.back();
              }
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
                  child: _buildLoginForm(context, controller, size, theme),
                ),
              ),
            ),
          ),
        ),
        if (controller.isLoading.value) _buildLoadingOverlay(theme),
      ],
    ));
  }

  Widget _buildLoginForm(BuildContext context, LoginController controller, Size size, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
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
              'https://placedog.net/300/200',
              height: size.height * 0.2,
              width: size.width * 0.4,
              fit: BoxFit.cover,
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
          Obx(() => _buildTextField(
            context: context,
            label: 'Contraseña',
            hint: 'Ingrese su contraseña',
            icon: Icons.lock,
            obscureText: controller.obscurePassword.value,
            controller: controller.passwordController,
            suffixIcon: IconButton(
              icon: Icon(
                controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                controller.togglePasswordVisibility();
                SoundService.playButton();
              },
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
            onPressed: controller.login,
            child: Text(
              'Ingresar',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: controller.goToRegister,
            child: Text(
              'Registrarse',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
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
    Widget? suffixIcon,
  }) {
    final ThemeData theme = Theme.of(context);
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
            suffixIcon: suffixIcon,
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
