import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_event_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddEventController());

    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
      body: SafeArea(
        child: Column(
          children: [
            // Header personalizado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: Color(0xFF75C9C8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
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
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildInputField(
                      label: 'Asignar un nombre al evento',
                      onChanged: (value) => controller.nombreEvento.value = value,
                    ),
                    const SizedBox(height: 20),
                    Obx(() => _buildDropdown(
                      label: 'Seleccionar Mascota',
                      value: controller.mascotaSeleccionada.value,
                      items: controller.mascotas,
                      onChanged: (nuevoValor) => controller.mascotaSeleccionada.value = nuevoValor!,
                    )),
                    const SizedBox(height: 20),
                    // Selector Lugar o Veterinaria
                    const Text('Lugar del Evento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3E0B53))),
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Escribir Manualmente', style: TextStyle(color: Color(0xFF3E0B53))),
                            value: 'manual',
                            groupValue: controller.tipoLugar.value,
                            onChanged: (valor) => controller.tipoLugar.value = valor!,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Veterinarias Guardadas', style: TextStyle(color: Color(0xFF3E0B53))),
                            value: 'veterinaria',
                            groupValue: controller.tipoLugar.value,
                            onChanged: (valor) => controller.tipoLugar.value = valor!,
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 10),

                    // Dependiendo lo que seleccionen
                    Obx(() {
                      if (controller.tipoLugar.value == 'manual') {
                        return _buildInputField(
                          label: 'Escribir lugar',
                          onChanged: (value) => controller.lugarEvento.value = value,
                        );
                      } else {
                        return _buildDropdown(
                          label: 'Seleccionar Veterinaria',
                          value: controller.veterinariaSeleccionada.value.isEmpty
                              ? controller.veterinarias.first
                              : controller.veterinariaSeleccionada.value,
                          items: controller.veterinarias,
                          onChanged: (nuevoValor) => controller.veterinariaSeleccionada.value = nuevoValor!,
                        );
                      }
                    }),
                    const SizedBox(height: 20),

                    // Fecha
                    Obx(() => _buildDatePicker(
                      context: context,
                      label: 'Fecha',
                      date: controller.fechaEvento.value,
                      onDateSelected: (fecha) => controller.fechaEvento.value = fecha,
                    )),
                    const SizedBox(height: 20),

                    // Hora
                    Obx(() => _buildTimePicker(
                      context: context,
                      label: 'Hora',
                      time: controller.horaEvento.value,
                      onTimeSelected: (hora) => controller.horaEvento.value = hora,
                    )),
                    const SizedBox(height: 20),

                    // Categoría
                    Obx(() => _buildDropdownCategoria(
                      label: 'Categoría',
                      value: controller.categoriaEvento.value,
                      items: controller.categorias,
                      onChanged: (nuevoValor) => controller.categoriaEvento.value = nuevoValor!,
                    )),

                    const SizedBox(height: 40),

                    // Botón Guardar
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _confirmarGuardado(context, controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E0B53),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Agregar Evento'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------
  // Widgets Secundarios
  // -------------------

  Widget _buildInputField({
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3E0B53))),
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

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime date,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3E0B53))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onTimeSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3E0B53))),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (pickedTime != null) {
              onTimeSelected(pickedTime);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3E0B53))),
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

  Widget _buildDropdownCategoria({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3E0B53))),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        item,
                        style: const TextStyle(color: Color(0xFF3E0B53), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _confirmarGuardado(BuildContext context, AddEventController controller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Deseas agregar este evento?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Agregar'),
            onPressed: () {
              Navigator.pop(context);
              Get.offAllNamed(AppRoutes.calendar);
              Get.snackbar(
                'Evento "${controller.nombreEvento.value}"',
                'Programado a las ${controller.horaEvento.value.format(context)}',
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }
}