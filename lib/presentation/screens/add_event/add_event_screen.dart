import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_event_controller.dart';
import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:animacare_front/routes/app_routes.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddEventController());

    return WillPopScope(
      onWillPop: () async {
        final hayCambios = controller.nombreEvento.value.isNotEmpty ||
                          controller.mascotaSeleccionada.value.isNotEmpty ||
                          (controller.tipoLugar.value == 'manual' && controller.lugarEvento.value.isNotEmpty) ||
                          (controller.tipoLugar.value == 'veterinaria' && controller.veterinariaSeleccionada.value.isNotEmpty) ||
                          controller.fechaEvento.value != null ||
                          controller.horaEvento.value != null ||
                          controller.categoriaEvento.value.isNotEmpty;

        if (hayCambios) {
          final salir = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('¿Descartar cambios?'),
              content: const Text('Tienes cambios sin guardar. ¿Seguro que quieres salir?'),
              actions: [
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
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      _buildInputField(
                        label: 'Asignar un nombre al evento',
                        onChanged: (value) => controller.nombreEvento.value = value,
                      ),
                      const SizedBox(height: 20),
                      Obx(() => _buildDropdown(
                        label: 'Seleccionar Mascota',
                        value: controller.mascotaSeleccionada.value.isEmpty
                            ? null
                            : controller.mascotaSeleccionada.value,
                        items: controller.mascotas,
                        onChanged: (v) => controller.mascotaSeleccionada.value = v ?? '',
                      )),
                      const SizedBox(height: 20),
                      _buildLugarSection(controller),
                      const SizedBox(height: 20),
                      _buildFechaHoraRow(context, controller),
                      const SizedBox(height: 20),
                      Obx(() => _buildDropdownCategoria(
                        label: 'Categoría',
                        value: controller.categoriaEvento.value.isEmpty
                            ? null
                            : controller.categoriaEvento.value,
                        items: controller.categorias,
                        onChanged: (v) => controller.categoriaEvento.value = v ?? '',
                      )),
                      const SizedBox(height: 40),
                      _buildGuardarButton(context, controller),
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

  // Header
  Widget _buildHeader(BuildContext context) {
    final controller = Get.find<AddEventController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(color: AppColors.header),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final hayCambios = controller.nombreEvento.value.isNotEmpty ||
                                controller.mascotaSeleccionada.value.isNotEmpty ||
                                (controller.tipoLugar.value == 'manual' && controller.lugarEvento.value.isNotEmpty) ||
                                (controller.tipoLugar.value == 'veterinaria' && controller.veterinariaSeleccionada.value.isNotEmpty) ||
                                controller.fechaEvento.value != null ||
                                controller.horaEvento.value != null ||
                                controller.categoriaEvento.value.isNotEmpty;

              if (hayCambios) {
                final salir = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('¿Descartar cambios?'),
                    content: const Text('Tienes cambios sin guardar. ¿Seguro que quieres salir?'),
                    actions: [
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
                if (salir == true) {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const Text(
            'Agregar Evento',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // Input Field
  Widget _buildInputField({
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Dropdown genérico
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: const Text('Seleccionar'),
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

  // Lugar Section
  Widget _buildLugarSection(AddEventController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lugar del Evento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        Obx(() => Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Escribir Manualmente', style: TextStyle(color: Colors.white)),
                value: 'manual',
                groupValue: controller.tipoLugar.value,
                onChanged: (v) => controller.tipoLugar.value = v!,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Veterinarias Guardadas', style: TextStyle(color: Colors.white)),
                value: 'veterinaria',
                groupValue: controller.tipoLugar.value,
                onChanged: (v) => controller.tipoLugar.value = v!,
              ),
            ),
          ],
        )),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.tipoLugar.value == 'manual') {
            return _buildInputField(
              label: 'Escribir lugar',
              onChanged: (v) => controller.lugarEvento.value = v,
            );
          } else {
            return _buildDropdown(
              label: 'Seleccionar Veterinaria',
              value: controller.veterinariaSeleccionada.value.isEmpty
                  ? null
                  : controller.veterinariaSeleccionada.value,
              items: controller.veterinarias,
              onChanged: (v) => controller.veterinariaSeleccionada.value = v ?? '',
            );
          }
        }),
      ],
    );
  }

  // Fecha y Hora Row
  Widget _buildFechaHoraRow(BuildContext context, AddEventController controller) {
    return Row(
      children: [
        Expanded(child: _buildFecha(context, controller)),
        const SizedBox(width: 10),
        Expanded(child: _buildHora(context, controller)),
      ],
    );
  }

  Widget _buildFecha(BuildContext context, AddEventController controller) {
    return Obx(() => GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          controller.fechaEvento.value = picked;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          controller.fechaEvento.value != null
              ? '${controller.fechaEvento.value!.day}/${controller.fechaEvento.value!.month}/${controller.fechaEvento.value!.year}'
              : 'Seleccionar Fecha',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));
  }

  Widget _buildHora(BuildContext context, AddEventController controller) {
    return Obx(() => GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          controller.horaEvento.value = picked;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          controller.horaEvento.value != null
              ? controller.horaEvento.value!.format(context)
              : 'Seleccionar Hora',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));
  }

  // Dropdown Categorías con Ícono y Color
  Widget _buildDropdownCategoria({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: const Text('Seleccionar'),
            isExpanded: true,
            underline: Container(),
            items: items.map((item) {
              IconData icon;
              Color color;
              switch (item.toLowerCase()) {
                case 'baño':
                  icon = Icons.shower;
                  color = Colors.blue;
                  break;
                case 'veterinario':
                  icon = Icons.local_hospital;
                  color = Colors.green;
                  break;
                case 'medicina':
                  icon = Icons.medical_services;
                  color = Colors.yellow.shade700;
                  break;
                case 'vacuna':
                  icon = Icons.vaccines;
                  color = Colors.lightBlueAccent;
                  break;
                default:
                  icon = Icons.pets;
                  color = Colors.purple;
              }
              return DropdownMenuItem(
                value: item,
                child: Row(
                  children: [
                    Icon(icon, color: color),
                    const SizedBox(width: 8),
                    Text(item),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Botón Guardar
  Widget _buildGuardarButton(BuildContext context, AddEventController controller) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.header,
          foregroundColor: AppColors.primaryWhite,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _validarGuardar(context, controller),
        child: const Text('Agregar Evento'),
      ),
    );
  }

  void _validarGuardar(BuildContext context, AddEventController controller) {
    if (controller.nombreEvento.value.isEmpty ||
        (controller.tipoLugar.value == 'manual' && controller.lugarEvento.value.isEmpty) ||
        (controller.tipoLugar.value == 'veterinaria' && controller.veterinariaSeleccionada.value.isEmpty) ||
        controller.fechaEvento.value == null ||
        controller.horaEvento.value == null ||
        controller.categoriaEvento.value.isEmpty) {
      Get.snackbar('Error', 'Por favor completa todos los campos.', backgroundColor: Colors.white, colorText: Colors.black);
    } else {
      _confirmarGuardado(context, controller);
    }
  }

  void _confirmarGuardado(BuildContext context, AddEventController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar Evento'),
        content: const Text('¿Deseas agregar este evento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.offAllNamed(AppRoutes.calendar);
              Get.snackbar(
                'Evento Agregado',
                'El evento se programó exitosamente.',
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
