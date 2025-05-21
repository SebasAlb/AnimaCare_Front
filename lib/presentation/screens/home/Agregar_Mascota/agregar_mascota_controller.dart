import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
      lastDate: DateTime(2035),
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

  /*
  Future<String?> _subirImagenACloudinary(File imageFile) async {
    const String cloudName = 'TU_CLOUDINARY_USER';
    const String uploadPreset = 'TU_UPLOAD_PRESET';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonData = json.decode(respStr);
      return jsonData['secure_url'];
    } else {
      return null;
    }
  }
  */

  Future<Mascota?> guardarMascota() async {
    // String? imageUrl;

    // if (fotoLocal != null) {
    //   imageUrl = await _subirImagenACloudinary(fotoLocal!);
    //   if (imageUrl == null) return null;
    // }

    return Mascota(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombreController.text,
      especie: especie,
      raza: razaController.text,
      fechaNacimiento: _parseFecha(fechaNacimientoController.text),
      sexo: sexo,
      peso: double.tryParse(pesoController.text) ?? 0,
      altura: double.tryParse(alturaController.text) ?? 0,
      fotoUrl: fotoLocal?.path ?? '', // ✅ solo almacena el path local por ahora
    );
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
