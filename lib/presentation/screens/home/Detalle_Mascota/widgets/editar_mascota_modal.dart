import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';
import 'package:provider/provider.dart';

class EditarMascotaModal {
  static void show(
    BuildContext context, {
    required Mascota mascota,
    required Map<String, TextEditingController> controllers,
    required void Function(Mascota) onGuardar,
  }) {
    final nombreController = TextEditingController(text: mascota.nombre);
    final _formKey = GlobalKey<FormState>();
    File? nuevaFoto;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      
      builder: (modalContext) {
        final theme = Theme.of(modalContext);

        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Editar información',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary)),
                  const SizedBox(height: 20),
                  _buildFotoPerfil(theme, mascota, () async {
                    final picker = ImagePicker();
                    final picked =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      nuevaFoto = File(picked.path);
                      (modalContext as Element).markNeedsBuild();
                    }
                  }, nuevaFoto),
                  const SizedBox(height: 20),
                  _campoTexto('Nombre', nombreController, theme),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: controllers['Especie']!.text,
                          decoration: _decoracionCampo(theme, label: 'Especie'),
                          items: ['Perro', 'Gato', 'Otro']
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) =>
                              controllers['Especie']!.text = val ?? '',
                          validator: (val) => val == null || val.isEmpty
                              ? 'Campo requerido'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _campoTexto('Raza', controllers['Raza']!, theme),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: controllers['Sexo']!.text,
                    decoration: _decoracionCampo(theme, label: 'Sexo'),
                    items: ['Macho', 'Hembra']
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) =>
                        controllers['Sexo']!.text = val ?? '',
                    validator: (val) => val == null || val.isEmpty
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final seleccionada = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2035),
                      );
                      if (seleccionada != null) {
                        controllers['Fecha de nacimiento']!.text =
                            '${seleccionada.day.toString().padLeft(2, '0')}/${seleccionada.month.toString().padLeft(2, '0')}/${seleccionada.year}';
                      }
                    },
                    child: AbsorbPointer(
                      child: _campoTexto('Cumpleaños',
                          controllers['Fecha de nacimiento']!, theme),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _campoTexto(
                          'Peso (kg)',
                          controllers['Peso']!..text =
                              controllers['Peso']!.text.replaceAll(' kg', ''),
                          theme,
                          type: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _campoTexto(
                          'Altura (cm)',
                          controllers['Altura']!..text =
                              controllers['Altura']!.text.replaceAll(' cm', ''),
                          theme,
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar cambios'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      mascota.nombre = nombreController.text;
                      mascota.especie = controllers['Especie']!.text;
                      mascota.raza = controllers['Raza']!.text;
                      mascota.sexo = controllers['Sexo']!.text;
                      mascota.peso = double.tryParse(controllers['Peso']!.text) ?? 0;
                      mascota.altura = double.tryParse(controllers['Altura']!.text) ?? 0;

                      final partes = controllers['Fecha de nacimiento']!.text.split('/');
                      if (partes.length == 3) {
                        mascota.fechaNacimiento = DateTime(
                          int.parse(partes[2]),
                          int.parse(partes[1]),
                          int.parse(partes[0]),
                        );
                      }

                      if (nuevaFoto != null) {
                        mascota.fotoUrl = nuevaFoto!.path;
                      }

                      onGuardar(mascota);

                      // 🔁 Asegura que la edad se recalcula también
                      context.read<DetalleMascotaController>().guardarCambiosDesdeFormulario(
                        nuevoNombre: mascota.nombre,
                      );

                      Navigator.pop(modalContext);
                    },

                  ),
                ],
              ),
            ),
          ),
        );
        
      },
    );
  }

  static Widget _campoTexto(String label, TextEditingController controller,
      ThemeData theme,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: _decoracionCampo(theme, label: label),
        style: theme.textTheme.titleMedium,
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  static InputDecoration _decoracionCampo(ThemeData theme,
      {required String label}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: theme.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
    );
  }

  static Widget _buildFotoPerfil(ThemeData theme, Mascota mascota,
      VoidCallback onEditar, File? nuevaFoto) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundImage: nuevaFoto != null
                ? FileImage(nuevaFoto)
                : (mascota.fotoUrl.isNotEmpty
                    ? (mascota.fotoUrl.startsWith('/') ||
                            mascota.fotoUrl.startsWith('file'))
                        ? FileImage(File(mascota.fotoUrl))
                        : NetworkImage(mascota.fotoUrl)
                            as ImageProvider
                    : const AssetImage('assets/images/perfil_mascota.png')),
            backgroundColor: theme.cardColor,
          ),
        ),
        FloatingActionButton.small(
          backgroundColor: theme.colorScheme.primary,
          onPressed: onEditar,
          child: const Icon(Icons.edit, size: 18),
        ),
      ],
    );
  }
}
