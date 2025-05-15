import 'package:flutter/material.dart';

class AgregarMascotaController {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();

  String sexo = 'Macho';

  final Color fondo = const Color(0xFFD5F3F1);
  final Color primario = const Color(0xFF14746F);
  final Color acento = const Color(0xFF1BB0A2);

  void initControllers() {
    // Inicialización adicional si necesitas
  }

  void disposeControllers() {
    nombreController.dispose();
    razaController.dispose();
    pesoController.dispose();
    alturaController.dispose();
    fechaNacimientoController.dispose();
  }

  Future<void> seleccionarFecha(
    BuildContext context,
    Function(String) onSelected,
  ) async {
    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: primario,
            onSurface: primario,
          ),
        ),
        child: child!,
      ),
    );
    if (seleccionada != null) {
      onSelected(
        '${seleccionada.day}/${seleccionada.month}/${seleccionada.year}',
      );
    }
  }

  void guardarMascota(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mascota guardada exitosamente'),
        backgroundColor: primario,
      ),
    );
  }
}
