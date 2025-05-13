import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_controller.dart';
import 'package:flutter/material.dart';

class EditarPerfilScreen extends StatelessWidget {
  const EditarPerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditarPerfilController controller = EditarPerfilController();

    return Scaffold(
      backgroundColor: const Color(0xFFD5F3F1),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                const CustomHeader(
                  nameScreen: 'Mi Perfil',
                  isSecondaryScreen: true,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: <Widget>[
                      _buildCampo('Nombres'),
                      _buildCampo('Apellidos'),
                      _buildCampo('Correo Electrónico'),
                      _buildCampo('Número de Teléfono'),
                      _buildCampo('Ciudad'),
                      _buildCampo('Dirección'),
                      _buildCampo('Otro'),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: controller.onCambiarContrasena,
                          child: const Text(
                            'Cambiar Contraseña',
                            style: TextStyle(
                                color: Colors.redAccent, fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1BB0A2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),),
                        ),
                        onPressed: controller.onGuardar,
                        child: const Text('Guardar', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo(String label) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
}
