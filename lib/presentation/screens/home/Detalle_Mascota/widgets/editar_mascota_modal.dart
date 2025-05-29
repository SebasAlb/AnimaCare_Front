import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';
import 'package:provider/provider.dart';
import 'package:animacare_front/services/pet_service.dart';
import 'package:animacare_front/presentation/screens/home/cloudinary_service.dart';

import 'package:animacare_front/services/sound_service.dart';
import 'package:get/get.dart';

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
    final ValueNotifier<bool> isLoading = ValueNotifier(false);

    showModalBottomSheet(
      //enableDrag: false, // ← bloquea arrastre hacia abajo
      //isDismissible: false, // ← bloquea tap fuera del modal
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        final theme = Theme.of(modalContext);

        return ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (_, loading, __) {
            return WillPopScope(
              onWillPop: () async => !loading,
              child: GestureDetector(
                onVerticalDragUpdate: loading ? (_) {} : null,
                child: AbsorbPointer(
                  absorbing: loading,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 24,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
                    ),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Form(
                        key: _formKey,
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Editar información',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildFotoPerfil(theme, mascota, () async {
                                    final picker = ImagePicker();
                                    final picked = await picker.pickImage(source: ImageSource.gallery);
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
                                        child: _dropdownValidado(
  label: 'Especie',
  theme: theme,
  icono: Icons.category,
  valorActual: controllers['Especie']!.text,
  opciones: ['Perro', 'Gato', 'Otro'],
  onChanged: (val) => controllers['Especie']!.text = val ?? '',
),

                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: _campoTexto('Raza', controllers['Raza']!, theme)),
                                    ],
                                  ),

                                  _dropdownValidado(
  label: 'Sexo',
  theme: theme,
  icono: Icons.male,
  valorActual: controllers['Sexo']!.text,
  opciones: ['Macho', 'Hembra'],
  onChanged: (val) => controllers['Sexo']!.text = val ?? '',
),


                                  GestureDetector(
                                    onTap: () async {
                                      final DateTime? seleccionada = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime.now(), // ✅ evita fechas futuras
                                        builder: (context, child) => Theme(
                                          data: ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: const Color(0xFF14746F), // o usa tu color exacto `primario` si lo tienes declarado
                                              onSurface: const Color(0xFF14746F),
                                            ),
                                          ),
                                          child: child!,
                                        ),
                                      );

                                      if (seleccionada != null) {
                                        controllers['Fecha de nacimiento']!.text =
                                            '${seleccionada.day.toString().padLeft(2, '0')}/${seleccionada.month.toString().padLeft(2, '0')}/${seleccionada.year}';
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: _campoTexto('Cumpleaños', controllers['Fecha de nacimiento']!, theme),
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
                                    onPressed: () async {
                                      //SoundService.playButton();
                                      if (!_formKey.currentState!.validate()) {
                                        SoundService.playWarning();
                                        return;
                                      }
                                      
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierColor: Colors.black.withOpacity(0.4),
                                        builder: (dialogContext) => WillPopScope(
                                          onWillPop: () async => false, // evita cerrar con botón atrás
                                          child: const Center(child: CircularProgressIndicator()),
                                        ),
                                      );

                                      try {
                                        SoundService.playButton();

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
                                          final url = await CloudinaryService.uploadImage(nuevaFoto!);
                                          if (url != null) mascota.fotoUrl = url;
                                        }

                                        onGuardar(mascota);
                                        await PetService().actualizarMascota(mascota, int.parse(mascota.id));

                                        SoundService.playSuccess();
                                        Get.snackbar(
                                          'Mascota actualizada',
                                          'La información fue guardada correctamente.',
                                          backgroundColor: Colors.white30,
                                          colorText: theme.colorScheme.onBackground,
                                          icon: const Icon(Icons.check_circle, color: Colors.green),
                                        );

                                        context.read<DetalleMascotaController>().guardarCambiosDesdeFormulario(
                                          nuevoNombre: mascota.nombre,
                                        );

                                        Navigator.pop(modalContext); // cerrar modal
                                      } catch (e) {
                                        SoundService.playWarning();
                                        Get.snackbar(
                                          'Error',
                                          'No se pudo guardar: $e',
                                          backgroundColor: Colors.white30,
                                          colorText: theme.colorScheme.onBackground,
                                          icon: const Icon(Icons.warning, color: Colors.redAccent),
                                        );
                                      } finally {
                                        Navigator.of(context, rootNavigator: true).pop(); // cerrar loader
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: isLoading,
                              builder: (_, loading, __) {
                                if (!loading) return const SizedBox.shrink();
                                return Positioned.fill(
                                  child: AbsorbPointer(
                                    child: Stack(
                                      children: [
                                        ModalBarrier(
                                          dismissible: false,
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                        const Center(child: CircularProgressIndicator()),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );


  }

  static Widget _campoTexto(
  String label,
  TextEditingController controller,
  ThemeData theme, {
  TextInputType type = TextInputType.text,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        ValueBuilder<String?>( // manejo visual de errores
          initialValue: null,
          builder: (errorText, updater) {
            final showError = errorText != null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller,
                  keyboardType: type,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Ingrese $label',
                    hintStyle: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                    prefixIcon: Icon(
                      label == 'Peso (kg)'
                          ? Icons.monitor_weight
                          : label == 'Altura (cm)'
                              ? Icons.height
                              : Icons.pets,
                      color: theme.colorScheme.primary,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: showError
                            ? Colors.red
                            : theme.colorScheme.primary.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: showError
                            ? Colors.red
                            : theme.colorScheme.primary.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: showError ? Colors.red : theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    errorText: showError ? '' : null,
                    errorStyle: const TextStyle(fontSize: 0, height: 0),
                  ),
                  validator: (value) {
                    final val = value?.trim() ?? '';

                    // Nombre: obligatorio
                    if (label == 'Nombre') {
                      if (val.isEmpty) {
                        updater('Campo requerido');
                        return '';
                      }
                    }

                    // Raza: solo letras si hay algo escrito
                    if (label == 'Raza' && val.isNotEmpty) {
                      if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(val)) {
                        updater('Solo se permiten letras');
                        return '';
                      }
                    }

                    // Peso / Altura: número válido si hay algo
                    if ((label.contains('Peso') || label.contains('Altura')) && val.isNotEmpty) {
                      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(val)) {
                        updater('Ingrese un número válido (ej. 12.5)');
                        return '';
                      } else if (double.tryParse(val)! <= 0) {
                        updater('Debe ser un número mayor a 0');
                        return '';
                      }
                    }

                    updater(null);
                    return null;
                  },
                  onChanged: (value) {
                    final val = value.trim();

                    if (label == 'Raza') {
                      if (val.isNotEmpty && !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(val)) {
                        updater('Solo se permiten letras');
                      } else {
                        updater(null);
                      }
                    } else if ((label.contains('Peso') || label.contains('Altura')) && val.isNotEmpty) {
                      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(val)) {
                        updater('Ingrese un número válido (ej. 12.5)');
                      } else if (double.tryParse(val)! <= 0) {
                        updater('Debe ser un número mayor a 0');
                      } else {
                        updater(null);
                      }
                    } else if (label == 'Nombre') {
                      updater(val.isEmpty ? 'Campo requerido' : null);
                    } else {
                      updater(null);
                    }
                  },
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 18,
                  child: showError
                      ? Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ],
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
  static _dropdownValidado({
  required String label,
  required ThemeData theme,
  required IconData icono,
  required String valorActual,
  required List<String> opciones,
  required void Function(String?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 2),
        ValueBuilder<bool?>(
          initialValue: false,
          builder: (hasError, updater) {
            final showError = hasError ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: valorActual.isNotEmpty ? valorActual : null,
                  items: opciones.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: onChanged,
                  decoration: InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  filled: true,
  fillColor: theme.cardColor,
  prefixIcon: Icon(icono, color: theme.colorScheme.primary),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: showError ? Colors.red : theme.colorScheme.primary.withOpacity(0.5),
      width: 1.5,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: showError ? Colors.red : theme.colorScheme.primary,
      width: 1.5,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red, width: 1.5),
  ),
),


                  validator: (val) {
                    final isValid = val != null && val.isNotEmpty;
                    updater(!isValid);
                    return null;
                  },
                ),
                const SizedBox(height: 0),
                SizedBox(
                  height: 18,
                  child: showError
                      ? const Text(
                          'Campo requerido',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

}






