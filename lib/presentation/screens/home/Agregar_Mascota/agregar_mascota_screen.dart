import 'package:animacare_front/models/mascota.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomHeader(
              nameScreen: 'Agregar Mascota',
              isSecondaryScreen: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            await controller.pickImage();
                            setState(() {});
                          },
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: theme.cardColor,
                            backgroundImage: controller.fotoLocal != null
                                ? FileImage(controller.fotoLocal!)
                                : null,
                            child: controller.fotoLocal == null
                                ? Icon(
                              Icons.camera_alt,
                              color: theme.colorScheme.primary,
                              size: 30,
                            )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        'Nombre',
                        'Ingrese el nombre de la mascota',
                        Icons.pets,
                        controller.nombreController,
                        theme,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              'Especie',
                              Icons.category,
                              theme,
                              controller.especie,
                              ['Perro', 'Gato', 'Otro'],
                                  (val) => setState(() => controller.especie = val!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              'Raza',
                              'Ingrese la raza',
                              Icons.pets_outlined,
                              controller.razaController,
                              theme,
                            ),
                          ),
                        ],
                      ),
                      _buildDropdownField(
                        'Sexo',
                        Icons.male,
                        theme,
                        controller.sexo,
                        ['Macho', 'Hembra'],
                            (val) => setState(() => controller.sexo = val!),
                      ),
                      GestureDetector(
                        onTap: () => controller.seleccionarFecha(context, (String fecha) {
                          setState(() {
                            controller.fechaNacimientoController.text = fecha;
                          });
                        }),
                        child: AbsorbPointer(
                          child: _buildTextField(
                            'Fecha de nacimiento',
                            'Seleccione la fecha',
                            Icons.cake,
                            controller.fechaNacimientoController,
                            theme,
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _buildTextField(
                              'Peso (kg)',
                              'Ej. 12.5',
                              Icons.monitor_weight,
                              controller.pesoController,
                              theme,
                              type: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              'Altura (cm)',
                              'Ej. 50',
                              Icons.height,
                              controller.alturaController,
                              theme,
                              type: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final Mascota? nueva = await controller.guardarMascota();
                            if (nueva != null) {
                              Navigator.pop(context, nueva);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Mascota guardada exitosamente'),
                                  backgroundColor: controller.primario,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al subir imagen'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Guardar Mascota',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller,
      ThemeData theme, {
        TextInputType type = TextInputType.text,
      }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
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
            TextFormField(
              controller: controller,
              keyboardType: type,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                prefixIcon: Icon(icon, color: theme.colorScheme.primary),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Campo requerido' : null,
            ),
          ],
        ),
      );

  Widget _buildDropdownField(
      String label,
      IconData icon,
      ThemeData theme,
      String selectedValue,
      List<String> items,
      void Function(String?) onChanged,
      ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
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
            DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor,
                prefixIcon: Icon(icon, color: theme.colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
              validator: (val) => (val == null || val.isEmpty) ? 'Campo requerido' : null,
            ),
          ],
        ),
      );
}
