import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';

class AgregarMascotaController {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  //Imagen
  final TextEditingController fotoUrlController = TextEditingController();

  String sexo = 'Macho';
  String especie = 'Perro'; // Se puede cambiar luego por un Dropdown

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
    fotoUrlController.dispose();
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

  Mascota guardarMascota() {
    return Mascota(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombreController.text,
      especie: especie,
      raza: razaController.text,
      fechaNacimiento: _parseFecha(fechaNacimientoController.text),
      sexo: sexo,
      peso: double.tryParse(pesoController.text) ?? 0,
      altura: double.tryParse(alturaController.text) ?? 0,
      fotoUrl: fotoUrlController.text,
    );
  }

  DateTime _parseFecha(String fecha) {
    final partes = fecha.split('/');
    return DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
  }
}

