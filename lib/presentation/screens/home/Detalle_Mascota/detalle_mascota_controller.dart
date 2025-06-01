import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/models/detalles_mascota.dart';
import 'package:animacare_front/services/pet_service.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

enum VistaDetalleMascota { info, historial, eventos }

class DetalleMascotaController extends ChangeNotifier {
  DetalleMascotaController(this.mascota) {
    _inicializarControllersDesdeMascota();
    cargarDetallesMascota();
  }

  Mascota mascota;
  final PetService _petService = PetService();

  int currentIndex = 0;
  String filtro = 'Todos';

  VistaDetalleMascota _vistaActual = VistaDetalleMascota.info;
  VistaDetalleMascota get vistaActual => _vistaActual;
  set vistaActual(VistaDetalleMascota vista) {
    _vistaActual = vista;
    notifyListeners();
  }

  bool isLoading = true;

  final ScrollController filtroScrollController = ScrollController();

  final Map<String, GlobalKey> filtroKeys = {
    'Todos': GlobalKey(),
    'Citas': GlobalKey(),
    'Vacunas': GlobalKey(),
    'Otros': GlobalKey(),
  };

  final Map<String, TextEditingController> controllers = {
    'Especie': TextEditingController(),
    'Raza': TextEditingController(),
    'Edad': TextEditingController(),
    'Fecha de nacimiento': TextEditingController(),
    'Peso': TextEditingController(),
    'Altura': TextEditingController(),
    'Sexo': TextEditingController(),
  };

  Map<String, List<Map<String, String>>> historialMedico = {};
  String proximoEvento = '';
  String fechaProximoEvento = '';
  List<EventoCalendar> eventosMascota = [];

  void setFiltro(String nuevoFiltro) {
    filtro = nuevoFiltro;
    notifyListeners();
  }

  Future<void> cargarDetallesMascota() async {
    try {
      isLoading = true;
      notifyListeners();

      final detalles = await _petService.obtenerDetallesMascota(mascota.id);

      // Organizar historial médico
      historialMedico.clear();
      for (var item in detalles.historial) {
        final categoria = _mapearCategoriaId(item.categoriaId);
        historialMedico.putIfAbsent(categoria, () => []);
        historialMedico[categoria]!.add({
          'descripcion': item.titulo,
          'fecha': DateFormat('dd/MM/yyyy').format(item.fecha),
        });
      }

      // Construir lista de eventos unificados
      eventosMascota = [
        ...detalles.eventos.map((e) => EventoCalendar(
          id: e.id.toString(),
          titulo: e.titulo,
          hora: '${e.hora.hour.toString().padLeft(2, '0')}:${e.hora.minute.toString().padLeft(2, '0')}',
          fecha: '${e.fecha.year}-${e.fecha.month.toString().padLeft(2, '0')}-${e.fecha.day.toString().padLeft(2, '0')}',
          mascota: mascota.nombre,
          veterinario: 'No especificado',
          tipo: 'evento',
          categoria: null,
          estado: null,
          descripcion: e.descripcion,
        )),
        ...detalles.citas.map((c) => EventoCalendar(
          id: c.id.toString(),
          titulo: c.razon,
          hora: '${c.hora.hour.toString().padLeft(2, '0')}:${c.hora.minute.toString().padLeft(2, '0')}',
          fecha: '${c.fecha.year}-${c.fecha.month.toString().padLeft(2, '0')}-${c.fecha.day.toString().padLeft(2, '0')}',
          mascota: mascota.nombre,
          veterinario: 'Veterinario asignado',
          tipo: 'cita',
          categoria: null,
          estado: c.estado,
          descripcion: c.descripcion,
        )),
      ];

      // Próximo evento (opcional)
      if (detalles.eventos.isNotEmpty) {
        detalles.eventos.sort((a, b) => a.fecha.compareTo(b.fecha));
        final evento = detalles.eventos.first;
        proximoEvento = evento.titulo;
        fechaProximoEvento = DateFormat('dd/MM/yyyy').format(evento.fecha);
      } else {
        proximoEvento = 'Sin eventos';
        fechaProximoEvento = '-';
      }

    } catch (e) {
      debugPrint('Error cargando detalles de mascota: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _mapearCategoriaId(String id) {
    switch (id) {
      case '1':
        return 'Vacunas';
      case '2':
        return 'Desparasitaciones';
      case '3':
        return 'Controles Generales';
      case '4':
        return 'Cirugías';
      default:
        return 'Otros';
    }
  }

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

    final fechaTexto = controllers['Fecha de nacimiento']?.text ?? '';
    if (fechaTexto.contains('/')) {
      final partes = fechaTexto.split('/');
      if (partes.length == 3) {
        try {
          final nuevaFecha = DateTime(
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

    notifyListeners();
  }

  void disposeControllers() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    filtroScrollController.dispose();
  }

  void _inicializarControllersDesdeMascota() {
    controllers['Especie']?.text = mascota.especie;
    controllers['Raza']?.text = mascota.raza;
    controllers['Edad']?.text = _calcularEdad(mascota.fechaNacimiento);
    controllers['Fecha de nacimiento']?.text = _formatoFecha(mascota.fechaNacimiento);
    controllers['Peso']?.text = mascota.peso == 0.0 ? '' : '${mascota.peso}';
    controllers['Altura']?.text = mascota.altura == 0.0 ? '' : '${mascota.altura}';
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

  String _formatoFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}
