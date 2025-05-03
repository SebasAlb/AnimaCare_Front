import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/presentation/screens/signup/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          controller.goBack();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF4DD0E2),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: <BoxShadow>const <BoxShadow>[
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
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFF301B92),),
                      label: const Text('Volver',
                          style: TextStyle(color: Color(0xFF301B92)),),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Crear Cuenta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF301B92),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    label: 'Nombre',
                    hint: 'Ingrese su nombre',
                    icon: Icons.person,
                    type: TextInputType.name,
                    controller: controller.firstNameController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Apellido',
                    hint: 'Ingrese su apellido',
                    icon: Icons.person_outline,
                    type: TextInputType.name,
                    controller: controller.lastNameController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Correo Electrónico',
                    icon: Icons.email,
                    hint: 'Ingrese su correo electrónico',
                    type: TextInputType.emailAddress,
                    controller: controller.emailController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Contraseña',
                    icon: Icons.lock,
                    hint: 'Ingrese una contraseña segura',
                    obscureText: true,
                    controller: controller.passwordController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Confirmar Contraseña',
                    icon: Icons.lock_outline,
                    hint: 'Confirme su contraseña',
                    obscureText: true,
                    controller: controller.confirmPasswordController,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF301B92),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),),
                    ),
                    onPressed: controller.signup,
                    child: const Text('Registrarse',
                        style: TextStyle(fontSize: 16, color: Colors.white),),
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
  }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF301B92),),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF301B92)),
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
