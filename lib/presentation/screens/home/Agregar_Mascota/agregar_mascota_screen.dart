import 'package:animacare_front/models/mascota.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_controller.dart';
import 'package:get/get.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/services.dart';

class AgregarMascotaScreen extends StatefulWidget {
  const AgregarMascotaScreen({super.key, this.isSecondaryScreen = false});
  final bool isSecondaryScreen;

  @override
  State<AgregarMascotaScreen> createState() => _AgregarMascotaScreenState();
}

class _AgregarMascotaScreenState extends State<AgregarMascotaScreen> {
  final AgregarMascotaController controller = AgregarMascotaController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxnString errorFecha = RxnString(); // ✅ inicializa como observable nulo

  

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

    return WillPopScope(
      onWillPop: () async => !isLoading.value,
      child: Obx(() => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
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
                                    ['Perro', 'Gato', 'Conejo', 'Hámsteres', 'Cuy', 'Huron', 'Canario', 'Periquito', 'Loro', 'Tortuga', 'Serpiente'],
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
                            _buildFechaNacimientoField(theme),


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
                                SoundService.playButton();
                              
                                final fechaValida = controller.fechaNacimientoController.text.trim().isNotEmpty;
                                errorFecha.value = fechaValida ? null : 'Campo requerido';
                              
                                if (_formKey.currentState!.validate() && fechaValida) {
                                  isLoading.value = true;
                              
                                  final Mascota? nueva = await controller.guardarMascota();
                                  isLoading.value = false;
                              
                                  if (nueva != null) {
                                    SoundService.playSuccess();
                                    Get.snackbar(
                                      'Éxito',
                                      'Mascota guardada exitosamente',
                                      backgroundColor: Colors.white30,
                                      colorText: theme.colorScheme.onBackground,
                                      icon: const Icon(Icons.check_circle, color: Colors.green),
                                    );
                                    Navigator.pop(context, nueva);
                                  } else {
                                    SoundService.playWarning();
                                    Get.snackbar(
                                      'Error',
                                      'Error al guardar la mascota',
                                      backgroundColor: Colors.white30,
                                      colorText: theme.colorScheme.onBackground,
                                      icon: const Icon(Icons.warning, color: Colors.redAccent),
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
          ),
          if (isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      )),
    );

    
  }

  Widget _buildTextField(
      String label,
      String hint,
      IconData icon,
      TextEditingController controller,
      ThemeData theme, {
        TextInputType type = TextInputType.text,
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
          ValueBuilder<String?>(
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
                    inputFormatters: (label == 'Nombre' || label == 'Raza')
                        ? [LengthLimitingTextInputFormatter(21)]
                        : (label.contains('Peso') || label.contains('Altura'))
                        ? [LengthLimitingTextInputFormatter(7)]
                        : [],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      prefixIcon: Icon(icon, color: theme.colorScheme.primary),
                      filled: true,
                      fillColor: theme.cardColor,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: showError
                            ? const BorderSide(color: Colors.red, width: 1.5)
                            : BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: showError
                            ? const BorderSide(color: Colors.red, width: 1.5)
                            : BorderSide.none,
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

                      if (label == 'Nombre') {
                        if (val.isEmpty) {
                          updater('Campo requerido');
                          return '';
                        }
                      }

                      if ((label == 'Nombre' || label == 'Raza') && val.length > 20) {
                        updater('Máximo 20 caracteres');
                        return '';
                      }

                      if (label == 'Raza' && val.isNotEmpty) {
                        if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(val)) {
                          updater('Solo se permiten letras');
                          return '';
                        }
                      }

                      if ((label.contains('Peso') || label.contains('Altura')) && val.isNotEmpty) {
                        if (!RegExp(r'^\d{1,3}(\.\d{1,3})?$').hasMatch(val)) {
                          updater('Formato: 999.999');
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
                      String val = value.trim();

                      if ((label == 'Nombre' || label == 'Raza') && val.length > 21) {
                        controller.text = val.substring(0, 21);
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        val = controller.text;
                      }

                      if ((label == 'Nombre' || label == 'Raza') && val.length > 20) {
                        updater('Máximo 20 caracteres');
                      } else if (label == 'Nombre' && val.isEmpty) {
                        updater('Campo requerido');
                      } else if (label == 'Raza') {
                        if (val.isNotEmpty &&
                            !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(val)) {
                          updater('Solo se permiten letras');
                        } else {
                          updater(null);
                        }
                      } else if ((label.contains('Peso') || label.contains('Altura')) &&
                          val.isNotEmpty) {
                        if (!RegExp(r'^\d{1,3}(\.\d{1,3})?$').hasMatch(val)) {
                          updater('Formato: 999.999');
                        } else if (double.tryParse(val)! <= 0) {
                          updater('Debe ser un número mayor a 0');
                        } else {
                          updater(null);
                        }
                      } else {
                        updater(null);
                      }
                    },
                  ),
                  const SizedBox(height: 4),
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


  Widget _buildDropdownField(
    String label,
    IconData icon,
    ThemeData theme,
    String selectedValue,
    List<String> items,
    void Function(String?) onChanged,
  ) {
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
                    isExpanded: true,
                    value: selectedValue.isNotEmpty ? selectedValue : null,
                    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: onChanged,

                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // igual al textfield
                      filled: true,
                      fillColor: theme.cardColor,
                      prefixIcon: Icon(icon, color: theme.colorScheme.primary),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
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
                  const SizedBox(height: 4),
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

  Widget _buildFechaNacimientoField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fecha de nacimiento',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Obx(() {
            final showError = errorFecha.value != null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.seleccionarFecha(context, (String fecha) {
                    controller.fechaNacimientoController.text = fecha;
                    errorFecha.value = null; // ✅ Limpia el error si hay fecha
                    setState(() {});
                  }),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: controller.fechaNacimientoController,
                      decoration: InputDecoration(
                        hintText: 'Seleccione la fecha',
                        prefixIcon: Icon(Icons.cake, color: theme.colorScheme.primary),
                        filled: true,
                        fillColor: theme.cardColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: showError
                              ? const BorderSide(color: Colors.red, width: 1.5)
                              : BorderSide.none,
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
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: 18,
                  child: showError
                      ? Text(
                          errorFecha.value!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

}

