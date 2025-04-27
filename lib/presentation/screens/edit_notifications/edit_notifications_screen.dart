import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_notifications_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditNotificationsScreen extends StatelessWidget {
  const EditNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditNotificationsController());

    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      body: SafeArea(
        child: Column(
          children: [
            // Header manual
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF75C9C8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Ajustes de Eventos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [

                    // 🔵 Sección Notificaciones
                    _buildSectionLabel('Configurar Notificaciones'),

                    Obx(() => _buildDropdown(
                      label: 'Anticipación del recordatorio',
                      value: controller.anticipacion.value,
                      items: ['1 día antes', '2 días antes', '3 días antes'],
                      onChanged: (nuevoValor) => controller.anticipacion.value = nuevoValor!,
                    )),
                    const SizedBox(height: 20),
                    
                    Obx(() => _buildDropdown(
                      label: 'Frecuencia de recordatorio',
                      value: controller.frecuencia.value,
                      items: ['Cada 6 horas', 'Cada 12 horas', 'Cada 24 horas'],
                      onChanged: (nuevoValor) => controller.frecuencia.value = nuevoValor!,
                    )),
                    const SizedBox(height: 20),
                    
                    Obx(() => _buildDropdown(
                      label: '¿Dónde recibir recordatorios?',
                      value: controller.recibirRecomendaciones.value,
                      items: ['Solo en la app', 'Solo en el celular', 'En app y celular', 'No recibir'],
                      onChanged: (nuevoValor) => controller.recibirRecomendaciones.value = nuevoValor!,
                    )),

                    const SizedBox(height: 30),

                    // 🔵 Sección Calendario
                    _buildSectionLabel('Configurar Calendario'),

                    _buildColorTile(
                      context: context,
                      label: 'Color de fondo del calendario',
                      color: controller.colorCalendario.value,
                      onTap: () {
                        _mostrarColorPicker(context, (color) {
                          controller.colorCalendario.value = color;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    _buildColorTile(
                      context: context,
                      label: 'Color de días cargados',
                      color: controller.colorDiasCargados.value,
                      onTap: () {
                        _mostrarColorPicker(context, (color) {
                          controller.colorDiasCargados.value = color;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    // 🔵 Sección Categorías
                    _buildSectionLabel('Configurar Categorías'),

                    ...controller.coloresCategorias.keys.map((categoria) {
                      return Obx(() => _buildColorTile(
                        context: context,
                        label: 'Color para $categoria',
                        color: controller.coloresCategorias[categoria]!,
                        icon: _iconoPorCategoria(categoria),
                        onTap: () {
                          _mostrarColorPicker(context, (color) {
                            controller.actualizarColorCategoria(categoria, color);
                          });
                        },
                      ));
                    }).toList(),

                    const SizedBox(height: 40),

                    // Botón Guardar Cambios
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.snackbar('¡Guardado!', 'Los cambios han sido aplicados.', 
                            backgroundColor: Colors.white, colorText: Colors.black);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E0B53),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Guardar Cambios'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔵 Helper: Sección Etiqueta Morada
  Widget _buildSectionLabel(String titulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3E0B53),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 🔵 Helper: Dropdown
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF3E0B53),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: Container(),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // 🔵 Helper: Card de color
  Widget _buildColorTile({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: ListTile(
          leading: icon != null ? Icon(icon, color: color) : null,
          title: Text(label),
          trailing: CircleAvatar(backgroundColor: color, radius: 14),
        ),
      ),
    );
  }

  // 🔵 Helper: Color picker
  void _mostrarColorPicker(BuildContext context, Function(Color) onColorSelected) {
    Color tempColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
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
        );
      },
    );
  }

  IconData _iconoPorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'baño':
        return Icons.shower;
      case 'veterinario':
        return Icons.local_hospital;
      case 'medicina':
        return Icons.medical_services;
      case 'vacuna':
        return Icons.vaccines;
      default:
        return Icons.pets;
    }
  }
}