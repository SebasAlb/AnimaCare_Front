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
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await controller.pickImage();
                          setState(
                              () {},); // <- para que se actualice visualmente
                        },
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: theme.cardColor,
                          backgroundImage: controller.fotoLocal != null
                              ? FileImage(controller.fotoLocal!)
                              : null,
                          child: controller.fotoLocal == null
                              ? Icon(Icons.camera_alt,
                                  color: theme.colorScheme.primary, size: 30,)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 🐶 Nombre (fila única)
                    _buildTextField(
                      label: 'Nombre',
                      controller: controller.nombreController,
                      icon: Icons.pets,
                      theme: theme,
                    ),

                    // 🐾 Especie + Raza (fila doble)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildTextField(
                            label: 'Especie',
                            controller:
                                TextEditingController(text: controller.especie),
                            icon: Icons.category,
                            theme: theme,
                            isDropdown: true,
                            items: <String>['Perro', 'Gato', 'Otro'],
                            onChangedDropdown: (val) =>
                                setState(() => controller.especie = val!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'Raza',
                            controller: controller.razaController,
                            icon: Icons.pets_outlined,
                            theme: theme,
                          ),
                        ),
                      ],
                    ),

                    // ⚧ Sexo (fila única)
                    _buildTextField(
                      label: 'Sexo',
                      controller: TextEditingController(text: controller.sexo),
                      icon: Icons.male,
                      theme: theme,
                      isDropdown: true,
                      items: <String>['Macho', 'Hembra'],
                      onChangedDropdown: (val) =>
                          setState(() => controller.sexo = val!),
                    ),

                    // 🎂 Fecha de nacimiento (fila única)
                    GestureDetector(
                      onTap: () =>
                          controller.seleccionarFecha(context, (String fecha) {
                        setState(() {
                          controller.fechaNacimientoController.text = fecha;
                        });
                      }),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          label: 'Fecha de nacimiento',
                          controller: controller.fechaNacimientoController,
                          icon: Icons.cake,
                          theme: theme,
                        ),
                      ),
                    ),

                    // ⚖️ Peso + Altura (fila doble)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _buildTextField(
                            label: 'Peso (kg)',
                            controller: controller.pesoController,
                            icon: Icons.monitor_weight,
                            theme: theme,
                            type: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            label: 'Altura (cm)',
                            controller: controller.alturaController,
                            icon: Icons.height,
                            theme: theme,
                            type: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final Mascota? nueva = await controller.guardarMascota();
                          if (nueva != null) {
                            Navigator.pop(context, nueva);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Mascota guardada exitosamente'),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required ThemeData theme,
    TextInputType type = TextInputType.text,
    bool isOptional = false,
    bool isDropdown = false,
    List<String>? items,
    void Function(String?)? onChangedDropdown,
  }) => Padding(
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
          isDropdown
              ? DropdownButtonFormField<String>(
                  value: controller.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.cardColor,
                    prefixIcon: Icon(icon, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.4),),
                    ),
                  ),
                  items: items!
                      .map((String e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onChangedDropdown,
                  validator: (String? value) =>
                      (value == null || value.isEmpty) && !isOptional
                          ? 'Campo requerido'
                          : null,
                )
              : TextFormField(
                  controller: controller,
                  keyboardType: type,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.textTheme.titleMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(icon, color: theme.colorScheme.primary),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.4),),
                    ),
                  ),
                  validator: (String? value) =>
                      (value == null || value.trim().isEmpty) && !isOptional
                          ? 'Campo requerido'
                          : null,
                ),
        ],
      ),
    );
}
