import 'package:animacare_front/presentation/screens/owner_update/owner_update_controller.dart';
import 'package:flutter/material.dart';

class UserOwnerScreen extends StatefulWidget {
  const UserOwnerScreen({Key? key}) : super(key: key);

  @override
  State<UserOwnerScreen> createState() => _UserOwnerScreenState();
}

class _UserOwnerScreenState extends State<UserOwnerScreen> {
  final OwnerUpdateController _controller = OwnerUpdateController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4DD0E2), // Fondo de toda la pantalla
      appBar: AppBar(
        backgroundColor: const Color(0xFF301B92), // Color del AppBar
        title: const Text(
          'Información Usuario (Dueño)',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 80, color: Color(0xFF222222)), // Ícono negro
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _controller.nameController,
                style: const TextStyle(color: Color(0xFF222222)), // Texto de input negro
                decoration: InputDecoration(
                  hintText: 'Nombre',
                  hintStyle: const TextStyle(color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _controller.lastNameController,
                style: const TextStyle(color: Color(0xFF222222)),
                decoration: InputDecoration(
                  hintText: 'Apellido',
                  hintStyle: const TextStyle(color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _controller.emailController,
                style: const TextStyle(color: Color(0xFF222222)),
                decoration: InputDecoration(
                  hintText: 'Correo Electrónico',
                  hintStyle: const TextStyle(color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función de cambiar contraseña aún no implementada')),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Cambiar Contraseña',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _controller.saveUserInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF301B92), // Botón de azul oscuro
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
    );
  }
}
