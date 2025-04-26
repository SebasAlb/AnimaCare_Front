import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton.icon(
                    onPressed: controller.goBack,
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF3E0B53)),
                    label: const Text('Volver', style: TextStyle(color: Color(0xFF3E0B53))),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E0B53),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  label: 'Nombre',
                  icon: Icons.person,
                  type: TextInputType.name,
                  onChanged: (value) => controller.firstName.value = value,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Apellido',
                  icon: Icons.person_outline,
                  type: TextInputType.name,
                  onChanged: (value) => controller.lastName.value = value,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Correo Electrónico',
                  icon: Icons.email,
                  type: TextInputType.emailAddress,
                  onChanged: (value) => controller.email.value = value,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  onChanged: (value) => controller.password.value = value,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Confirmar Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  onChanged: (value) => controller.confirmPassword.value = value,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E0B53),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.signup,
                  child: const Text('Registrarse', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool obscureText = false,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E0B53)),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: type,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF3E0B53)),
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
