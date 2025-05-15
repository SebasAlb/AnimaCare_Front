import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_controller.dart';

class AgregarMascotaScreen extends StatefulWidget {
  const AgregarMascotaScreen({super.key, this.isSecondaryScreen = false});
  final bool isSecondaryScreen;

  @override
  State<AgregarMascotaScreen> createState() => _AgregarMascotaScreenState();
}

class _AgregarMascotaScreenState extends State<AgregarMascotaScreen> {
  final AgregarMascotaController controller = AgregarMascotaController();

  @override
  void initState() {
    super.initState();
    controller.initControllers();
  }

  @override
  void dispose() {
    controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(
              nameScreen: 'Agregar Mascota',
              isSecondaryScreen: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 24),
                  _buildTextField('Nombre', controller.nombreController, Icons.pets, theme),
                  _buildTextField('Raza', controller.razaController, Icons.pets_outlined, theme),
                  _buildTextField('Peso (kg)', controller.pesoController, Icons.monitor_weight, theme, type: TextInputType.number),
                  _buildTextField('Altura (cm)', controller.alturaController, Icons.height, theme, type: TextInputType.number),
                  GestureDetector(
                    onTap: () => controller.seleccionarFecha(context, (String fecha) {
                      setState(() {
                        controller.fechaNacimientoController.text = fecha;
                      });
                    }),
                    child: AbsorbPointer(
                      child: _buildTextField('Cumpleaños', controller.fechaNacimientoController, Icons.cake, theme),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Sexo', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  Row(
                    children: ['Macho', 'Hembra'].map((String option) {
                      return Expanded(
                        child: RadioListTile(
                          title: Text(option, style: theme.textTheme.bodyMedium),
                          value: option,
                          groupValue: controller.sexo,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) {
                            setState(() => controller.sexo = value.toString());
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      controller.guardarMascota(context);
                    },
                    child: const Text(
                      'Guardar Mascota',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon,
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
