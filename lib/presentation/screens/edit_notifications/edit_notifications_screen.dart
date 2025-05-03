import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/presentation/screens/edit_notifications/edit_notifications_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:animacare_front/presentation/theme/colors.dart';

class EditNotificationsScreen extends StatelessWidget {
  const EditNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditNotificationsController controller = Get.put(EditNotificationsController());

    return WillPopScope(
      onWillPop: () => _confirmarSalida(context, controller),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _buildHeader(
                  context, controller,), // Ahora el header recibe controller
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: <Widget>[
                      _buildSectionLabel('Configurar Recomendaciones'),
                      _buildDropdowns(controller),
                      const SizedBox(height: 20),
                      _buildProbarNotificacionButton(),
                      const SizedBox(height: 30),
                      _buildSectionLabel('Colores de Calendario'),
                      _buildCalendarioColors(context, controller),
                      const SizedBox(height: 30),
                      _buildCategoriasSection(context, controller),
                      const SizedBox(height: 40),
                      _buildGuardarButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, EditNotificationsController controller,) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: AppColors.header),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryWhite),
            onPressed: () async {
              final bool salir = await _confirmarSalida(context, controller);
              if (salir) Navigator.pop(context);
            },
          ),
          const Text(
            'Ajustes de Calendario',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.primaryWhite,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );

  Widget _buildSectionLabel(String titulo) => Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.header,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        titulo,
        style: const TextStyle(
          color: AppColors.primaryWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

  Widget _buildDropdowns(EditNotificationsController controller) => Column(
      children: <Widget>[
        const SizedBox(height: 15),
        // Primero "¿Dónde recibir recordatorios?"
        Obx(() => _buildDropdown(
              label: '¿Dónde desea recibir recomendaciones del vetenerianario?',
              value: controller.recibirRecomendaciones.value,
              items: <String>[
                'Solo en la app',
                'Solo en el celular',
                'En app y celular',
                'No recibir',
              ],
              onChanged: (String? v) => controller.recibirRecomendaciones.value = v!,
            ),),
        const SizedBox(height: 10),

        //  Solo si NO elige "No recibir", mostramos los otros dos campos
        Obx(() {
          if (controller.recibirRecomendaciones.value == 'No recibir') {
            return const SizedBox.shrink();
          } else {
            return Column(
              children: <Widget>[
                _buildDropdown(
                  label: 'Anticipación del recordatorio',
                  value: controller.anticipacion.value,
                  items: <String>['1 día antes', '2 días antes', '3 días antes'],
                  onChanged: (String? v) => controller.anticipacion.value = v!,
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  label: 'Frecuencia de recordatorio',
                  value: controller.frecuencia.value,
                  items: <String>['Cada 6 horas', 'Cada 12 horas', 'Cada 24 horas'],
                  onChanged: (String? v) => controller.frecuencia.value = v!,
                ),
              ],
            );
          }
        }),
      ],
    );

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primaryWhite,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: Container(),
            items: items.map((String item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );

  Widget _buildProbarNotificacionButton() => Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.header,
          foregroundColor: AppColors.primaryWhite,
        ),
        onPressed: () {
          Get.snackbar(
              'Notificación de prueba', 'Esta es una notificación de ejemplo.',
              backgroundColor: AppColors.primaryWhite, colorText: Colors.black,);
        },
        child: const Text('Probar notificación'),
      ),
    );

  Widget _buildCalendarioColors(
      BuildContext context, EditNotificationsController controller,) => Column(
      children: <Widget>[
        const SizedBox(height: 15),
        Obx(() => _buildColorTile(
              context: context,
              label: 'Color de fondo del calendario',
              color: controller.colorCalendario.value,
              onTap: () {
                _mostrarColorPicker(context,
                    (Color color) => controller.colorCalendario.value = color,);
              },
            ),),
        const SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: Obx(() => _buildColorTile(
                    context: context,
                    label: 'Color de días cargados',
                    color: controller.colorDiasCargados.value,
                    onTap: () {
                      _mostrarColorPicker(
                          context,
                          (Color color) =>
                              controller.colorDiasCargados.value = color,);
                    },
                  ),),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Get.defaultDialog(
                    title: 'Información',
                    middleText: 'Días cargados son días con más de 4 eventos.',);
              },
            ),
          ],
        ),
      ],
    );

  Widget _buildColorTile(
      {required BuildContext context,
      required String label,
      required Color color,
      required VoidCallback onTap,}) => GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(label),
          trailing: CircleAvatar(backgroundColor: color, radius: 14),
        ),
      ),
    );

  Widget _buildCategoriasSection(
      BuildContext context, EditNotificationsController controller,) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: _buildSectionLabel('Configurar Categorías')),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _mostrarAgregarCategoria(context, controller);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() => Column(
              children: controller.categorias.entries.map((MapEntry<String, Map<String, dynamic>> e) {
                final String nombre = e.key;
                final color = e.value['color'];
                final icono = e.value['icon'];

                return Card(
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        _mostrarSeleccionarIcono(context, controller, nombre);
                      },
                      child: Icon(icono, color: color),
                    ),
                    title: GestureDetector(
                      onTap: () => _mostrarEditarNombreCategoria(
                          context, controller, nombre,),
                      child: Text(nombre),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.color_lens_outlined),
                          onPressed: () {
                            _mostrarColorPicker(
                                context,
                                (Color color) => controller.actualizarColorCategoria(
                                    nombre, color,),);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            _mostrarConfirmarEliminar(
                                context, controller, nombre,);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),),
      ],
    );

  Widget _buildGuardarButton() => Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.header,
          foregroundColor: AppColors.primaryWhite,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Get.snackbar('¡Guardado!', 'Los cambios han sido aplicados.',
              backgroundColor: AppColors.primaryWhite, colorText: Colors.black,);
        },
        child: const Text('Guardar Cambios'),
      ),
    );

  void _mostrarColorPicker(
      BuildContext context, Function(Color) onColorSelected,) {
    Color tempColor = Colors.blue;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seleccionar Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) {
              tempColor = color;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              onColorSelected(tempColor);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarSeleccionarIcono(BuildContext context,
      EditNotificationsController controller, String categoria,) {
    IconData? selectedIcon;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seleccionar Icono'),
        content: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            _iconOption(Icons.shower, context, (icon) {
              selectedIcon = icon;
              if (categoria.isNotEmpty) {
                controller.actualizarIconoCategoria(categoria, icon);
                Navigator.pop(context);
              }
            }),
            _iconOption(Icons.local_hospital, context, (icon) {
              selectedIcon = icon;
              if (categoria.isNotEmpty) {
                controller.actualizarIconoCategoria(categoria, icon);
                Navigator.pop(context);
              }
            }),
            _iconOption(Icons.medical_services, context, (icon) {
              selectedIcon = icon;
              if (categoria.isNotEmpty) {
                controller.actualizarIconoCategoria(categoria, icon);
                Navigator.pop(context);
              }
            }),
            _iconOption(Icons.vaccines, context, (icon) {
              selectedIcon = icon;
              if (categoria.isNotEmpty) {
                controller.actualizarIconoCategoria(categoria, icon);
                Navigator.pop(context);
              }
            }),
            _iconOption(Icons.pets, context, (icon) {
              selectedIcon = icon;
              if (categoria.isNotEmpty) {
                controller.actualizarIconoCategoria(categoria, icon);
                Navigator.pop(context);
              }
            }),
          ],
        ),
        actions: <Widget>[
          if (categoria.isEmpty)
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                if (selectedIcon != null) {
                  Navigator.pop(context, selectedIcon);
                } else {
                  Get.snackbar('Error', 'Debes seleccionar un ícono');
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _iconOption(
      IconData icon, BuildContext context, Function(IconData) onSelected,) => IconButton(
      icon: Icon(icon, size: 30),
      onPressed: () => onSelected(icon),
    );

  void _mostrarAgregarCategoria(
      BuildContext context, EditNotificationsController controller,) {
    final TextEditingController nombreController = TextEditingController();
    Color? selectedColor;
    IconData? selectedIcon;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Agregar Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de la categoría'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _mostrarColorPicker(context, (color) {
                  selectedColor = color;
                  setState(() {});
                }),
                child: const Text('Seleccionar Color'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final IconData? icono = await showDialog<IconData>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Seleccionar Icono'),
                      content: Wrap(
                        children: <Widget>[
                          _iconOption(Icons.shower, context,
                              (icon) => Navigator.pop(context, icon),),
                          _iconOption(Icons.local_hospital, context,
                              (icon) => Navigator.pop(context, icon),),
                          _iconOption(Icons.medical_services, context,
                              (icon) => Navigator.pop(context, icon),),
                          _iconOption(Icons.vaccines, context,
                              (icon) => Navigator.pop(context, icon),),
                          _iconOption(Icons.pets, context,
                              (icon) => Navigator.pop(context, icon),),
                        ],
                      ),
                    ),
                  );
                  if (icono != null) {
                    selectedIcon = icono;
                    setState(() {});
                  }
                },
                child: const Text('Seleccionar Icono'),
              ),
              const SizedBox(height: 10),
              if (selectedColor != null || selectedIcon != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (selectedColor != null)
                      CircleAvatar(backgroundColor: selectedColor, radius: 14),
                    const SizedBox(width: 10),
                    if (selectedIcon != null) Icon(selectedIcon),
                  ],
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                final String nombre = nombreController.text.trim();
                if (nombre.isEmpty ||
                    selectedColor == null ||
                    selectedIcon == null) {
                  Get.snackbar('Error', 'Debes completar todos los campos.');
                } else {
                  controller.agregarCategoria(
                      nombre, selectedColor!, selectedIcon!,);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarEditarNombreCategoria(BuildContext context,
      EditNotificationsController controller, String oldName,) {
    final TextEditingController nombreController =
        TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar Nombre de Categoría'),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(labelText: 'Nuevo nombre'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Guardar'),
            onPressed: () {
              final String nuevoNombre = nombreController.text.trim();
              if (nuevoNombre.isNotEmpty) {
                controller.actualizarNombreCategoria(oldName, nuevoNombre);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarConfirmarEliminar(BuildContext context,
      EditNotificationsController controller, String categoria,) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: Text('¿Estás seguro que deseas eliminar "$categoria"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () {
              controller.eliminarCategoria(categoria);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmarSalida(
      BuildContext context, EditNotificationsController controller,) async {
    final bool hayCambios = controller.anticipacion.value != '1 día antes' ||
        controller.frecuencia.value != 'Cada 6 horas' ||
        controller.recibirRecomendaciones.value != 'Solo en la app' ||
        controller.colorCalendario.value != const Color(0xFFFFFFFF) ||
        controller.colorDiasCargados.value != const Color(0xFFFFA726) ||
        controller.categorias.length != 4; // Cambio en número de categorías

    if (hayCambios) {
      final bool? salir = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¿Descartar cambios?'),
          content: const Text(
              'Tienes cambios sin guardar. ¿Seguro que quieres salir?',),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salir'),
            ),
          ],
        ),
      );
      return salir ?? false;
    }

    return true;
  }
}
