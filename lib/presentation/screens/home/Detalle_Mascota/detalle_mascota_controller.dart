import 'package:animacare_front/models/mascota.dart';
import 'package:flutter/material.dart';

//Version 2
// ✅ Ahora extiende de ChangeNotifier para que pueda notificar cambios
class DetalleMascotaController extends ChangeNotifier {
  DetalleMascotaController(this.mascota) {
    _inicializarControllersDesdeMascota();
  }

  Mascota mascota;

  int currentIndex = 0;
  String filtro = 'Todos';
  bool _mostrarHistorial = false;

  bool get mostrarHistorial => _mostrarHistorial;

  set mostrarHistorial(bool value) {
    _mostrarHistorial = value;
    notifyListeners(); // 🔄 Esto asegura que la UI se actualice
  }

  final ScrollController filtroScrollController = ScrollController();

  final Map<String, GlobalKey> filtroKeys = <String, GlobalKey<State<StatefulWidget>>>{
    'Todos': GlobalKey(),
    'Citas': GlobalKey(),
    'Vacunas': GlobalKey(),
    'Otros': GlobalKey(),
  };

  final Map<String, TextEditingController> controllers = <String, TextEditingController>{
    'Especie': TextEditingController(),
    'Raza': TextEditingController(),
    'Edad': TextEditingController(),
    'Fecha de nacimiento': TextEditingController(),
    'Peso': TextEditingController(),
    'Altura': TextEditingController(),
    'Sexo': TextEditingController(),
  };

  final Map<String, List<Map<String, String>>> historialMedico = <String, List<Map<String, String>>>{
    'Vacunas': <Map<String, String>>[
      <String, String>{'fecha': '01/01/2023', 'descripcion': 'Vacuna contra moquillo'},
      <String, String>{'fecha': '01/06/2023', 'descripcion': 'Vacuna contra rabia'},
    ],
    'Desparasitaciones': <Map<String, String>>[
      <String, String>{'fecha': '15/03/2023', 'descripcion': 'Desparasitación interna'},
      <String, String>{'fecha': '15/07/2023', 'descripcion': 'Desparasitación externa'},
    ],
    'Controles Generales': <Map<String, String>>[
      <String, String>{'fecha': '10/05/2023', 'descripcion': 'Chequeo general'},
    ],
    'Cirugías': <Map<String, String>>[
      <String, String>{'fecha': '12/12/2022', 'descripcion': 'Esterilización'},
    ],
  };

  final String proximoEvento = 'Vacuna contra moquillo';
  final String fechaProximoEvento = '10/01/2024';

  void setFiltro(String nuevoFiltro) {
    filtro = nuevoFiltro;
    notifyListeners();
  }

  // Actualiza los datos del modelo Mascota desde el formulario de edición y notifica a la UI
  void guardarCambiosDesdeFormulario({required String nuevoNombre}) {
    mascota.nombre = nuevoNombre;
    mascota.especie = controllers['Especie']?.text ?? '';
    mascota.raza = controllers['Raza']?.text ?? '';
    mascota.sexo = controllers['Sexo']?.text ?? '';
    mascota.peso = double.tryParse(
          (controllers['Peso']?.text ?? '').replaceAll(' kg', ''),
        ) ??
        0;

    mascota.altura = double.tryParse(
          (controllers['Altura']?.text ?? '').replaceAll(' cm', ''),
        ) ??
        0;

    final String fechaTexto = controllers['Fecha de nacimiento']?.text ?? '';
    if (fechaTexto.contains('/')) {
      final List<String> partes = fechaTexto.split('/');
      if (partes.length == 3) {
        try {
          final DateTime nuevaFecha = DateTime(
            int.parse(partes[2]),
            int.parse(partes[1]),
            int.parse(partes[0]),
          );
          mascota.fechaNacimiento = nuevaFecha;
          controllers['Edad']?.text = _calcularEdad(nuevaFecha);
        } catch (e) {
          debugPrint('❌ Error al parsear fecha: $e');
        }
      }
    }

    notifyListeners(); // 🔄 Actualiza la UI
  }

  void disposeControllers() {
    for (final TextEditingController controller in controllers.values) {
      controller.dispose();
    }
    filtroScrollController.dispose();
  }

  void _inicializarControllersDesdeMascota() {
    controllers['Especie']?.text = mascota.especie;
    controllers['Raza']?.text = mascota.raza;
    controllers['Edad']?.text = _calcularEdad(mascota.fechaNacimiento);
    controllers['Fecha de nacimiento']?.text =
        _formatoFecha(mascota.fechaNacimiento);
    controllers['Peso']?.text = '${mascota.peso} kg';
    controllers['Altura']?.text = '${mascota.altura} cm';
    controllers['Sexo']?.text = mascota.sexo;
  }

  String _calcularEdad(DateTime fechaNacimiento) {
    final DateTime ahora = DateTime.now();
    int anios = ahora.year - fechaNacimiento.year;
    int meses = ahora.month - fechaNacimiento.month;

    if (meses < 0) {
      anios--;
      meses += 12;
    }

    return '$anios años y $meses meses';
  }

  String _formatoFecha(DateTime fecha) => '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
}
