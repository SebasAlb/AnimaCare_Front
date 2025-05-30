import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animacare_front/services/pet_service.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';
import 'package:animacare_front/presentation/screens/home/cloudinary_service.dart';

import 'package:animacare_front/storage/pet_storage.dart'; // NUEVO

class AgregarMascotaController {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController fotoUrlController = TextEditingController();

  String sexo = 'Macho';
  String especie = 'Perro';

  File? fotoLocal;

  final Color fondo = const Color(0xFFD5F3F1);
  final Color primario = const Color(0xFF14746F);
  final Color acento = const Color(0xFF1BB0A2);

  void initControllers() {}

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
      lastDate: DateTime.now(), // ✅ evita fechas futuras
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
        '${seleccionada.day.toString().padLeft(2, '0')}/'
        '${seleccionada.month.toString().padLeft(2, '0')}/'
        '${seleccionada.year}',
      );
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      fotoLocal = File(image.path);
    }
  }


  Future<Mascota?> guardarMascota() async {
    final Dueno? dueno = UserStorage.getUser();
    if (dueno == null) return null;

    final PetService petService = PetService();

    try {
      String imageUrl = '';

      if (fotoLocal != null) {
        final String? subida = await CloudinaryService.uploadImage(fotoLocal!);
        if (subida != null) {
          imageUrl = subida;
        } else {
          print('❌ No se pudo subir la imagen a Cloudinary.');
          return null;
        }
      }

      final Mascota nuevaMascota = Mascota(
        id: 0, // será asignado por backend
        nombre: nombreController.text.trim(),
        especie: especie,
        raza: razaController.text.trim().isEmpty ? '' : razaController.text.trim(),
        fechaNacimiento: _parseFecha(fechaNacimientoController.text.trim()),
        sexo: sexo,
        peso: double.tryParse(pesoController.text.trim()) ?? 0,
        altura: double.tryParse(alturaController.text.trim()) ?? 0,
        fotoUrl: imageUrl,
      );


      final Mascota mascotaCreada =
          await petService.crearMascota(nuevaMascota, dueno.id);
      // ✅ ACTUALIZAR STORAGE LOCAL
      MascotasStorage.saveMascotas([...MascotasStorage.getMascotas(), mascotaCreada]);
      return mascotaCreada;
    } catch (e) {
      print('Error al guardar mascota: $e');
      return null;
    }
  }


  DateTime _parseFecha(String fecha) {
    final List<String> partes = fecha.split('/');
    return DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
  }
}





