import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/storage/veterinarian_storage.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:get/get.dart';
import 'package:animacare_front/models/cita.dart';
import 'package:animacare_front/services/appointment_service.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:animacare_front/services/veterinarian_service.dart';



class AgendarCitaController {
  final VeterinarianService _service = VeterinarianService();
  final theme = Theme.of(Get.context!);
  Future<List<Veterinario>> cargarVeterinarios() async {
    try {
      final data = await _service.fetchVeterinarios();
      VeterinariosStorage.clearVeterinarios();
      VeterinariosStorage.saveVeterinarios(data);
      return data;
    } catch (e) {
      SoundService.playWarning();
      Get.snackbar(
        'Error',
        'Error al obtener los horarios de los veterinarios.',
        backgroundColor: Colors.white30,
        colorText: theme.colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return [];
    }
  }

  final List<String> razones = <String>[
    'Consulta general',
    'Vacunación',
    'Desparasitación',
    'Control postoperatorio',
    'Emergencia',
    'Chequeo geriátrico',
  ];

  // ✅ Se reemplaza ContactsController por una lista real de veterinarios
  List<Veterinario> contactosExternos = [];
  List<Mascota> mascotas = [];

  List<String> get veterinariosDisponibles =>
      contactosExternos.map((v) => v.nombreCompleto).toList();

  Mascota? mascotaSeleccionada;
  String? razonSeleccionada;
  Veterinario? veterinarioSeleccionado;
  DateTime? fechaSeleccionada;
  String? horaSeleccionada;

  final TextEditingController notasController = TextEditingController();

  Future<void> seleccionarFecha(BuildContext context) async {
    final DateTime hoy = DateTime.now();

    DateTime fechaInicial = hoy;
    while (estaDiaBloqueadoPorExcepcion(fechaInicial) || diaNoLaboral(fechaInicial)) {
      fechaInicial = fechaInicial.add(const Duration(days: 1));
    }

    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 90)),
      selectableDayPredicate: (day) =>
      !estaDiaBloqueadoPorExcepcion(day) && !diaNoLaboral(day),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4B1B3F),
            onSurface: Color(0xFF4B1B3F),
          ),
        ),
        child: child!,
      ),
    );

    if (fecha != null) {
      fechaSeleccionada = fecha;
    }
  }

  bool estaDiaBloqueadoPorExcepcion(DateTime dia) {
    final vet = veterinarioSeleccionado;
    if (vet == null) return false;

    return vet.excepciones.any((e) {
      if (!e.disponible) {
        final mismaFecha = e.fecha.year == dia.year &&
            e.fecha.month == dia.month &&
            e.fecha.day == dia.day;

        if (!mismaFecha) return false;

        // Si la excepción cubre todo el día, se bloquea el día entero
        final inicio = _combinarFechaHora(e.fecha, e.horaInicio);
        final fin = _combinarFechaHora(e.fecha, e.horaFin);

        final cubreTodoElDia = inicio.hour <= 8 && fin.hour >= 17;
        return cubreTodoElDia;
      }
      return false;
    });
  }

  bool _cubreTodoElDia(VeterinarioExcepcion e, DateTime dia) {
    final diaCompletoInicio = DateTime(dia.year, dia.month, dia.day, 0, 0);
    final diaCompletoFin = DateTime(dia.year, dia.month, dia.day, 23, 59);
    final inicio = _combinarFechaHora(e.fecha, e.horaInicio);
    final fin = _combinarFechaHora(e.fecha, e.horaFin);
    return inicio.isBefore(diaCompletoInicio) && fin.isAfter(diaCompletoFin);
  }

  bool horaBloqueadaPorExcepcion(DateTime fecha, String horaBloque) {
    final vet = veterinarioSeleccionado;
    if (vet == null) return false;

    // Extraer solo la hora del bloque: "08:00 - 09:00" => "08:00"
    final partes = horaBloque.split(' - ');
    if (partes.length != 2) return false;
    final horaInicioBloque = partes[0];

    final horaParts = horaInicioBloque.split(':');
    final horaActual = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(horaParts[0]),
      int.parse(horaParts[1]),
    );

    return vet.excepciones.any((e) {
      if (!e.disponible && _esMismaFecha(e.fecha, fecha)) {
        final inicio = _combinarFechaHora(e.fecha, e.horaInicio);
        final fin = _combinarFechaHora(e.fecha, e.horaFin);
        return horaActual.isAfter(inicio.subtract(const Duration(minutes: 1))) &&
            horaActual.isBefore(fin);
      }
      return false;
    });
  }

  bool _esMismaFecha(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _combinarFechaHora(DateTime fecha, String horaISO) {
    final hora = DateTime.parse(horaISO);
    return DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
  }

  Future<void> mostrarSelectorHora(
      BuildContext context,
      VoidCallback refreshUI,
      ) async {
    if (veterinarioSeleccionado == null || fechaSeleccionada == null) return;

    final ThemeData theme = Theme.of(context);
    final vet = veterinarioSeleccionado;
    if (vet == null) return;

    final List<String> horasDisponibles = _obtenerHorasDisponiblesParaFecha(
      vet,
      fechaSeleccionada!,
      horasOcupadasSimuladas: ['10:00', '12:00'], // Simulación
    );

    final String nombreDia = _nombreDia(fechaSeleccionada!.weekday);
    final String fechaFormateada =
        '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}';

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '$nombreDia $fechaFormateada',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selecciona una hora',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: horasDisponibles.map((String hora) {
                  final bloqueada =
                  horaBloqueadaPorExcepcion(fechaSeleccionada!, hora);
                  return ElevatedButton(
                    onPressed: bloqueada
                        ? null
                        : () {
                      SoundService.playButton();
                      horaSeleccionada = hora;
                      Navigator.pop(context);
                      refreshUI();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bloqueada
                          ? Colors.red[300]
                          : theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimary,
                      minimumSize: const Size(100, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(hora),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> guardarCita(BuildContext context) async {
    if (!camposObligatoriosLlenos) {
      SoundService.playWarning();
      Get.snackbar(
        'Campos requeridos',
        'Completa todos los campos obligatorios.',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    final cita = Cita(
      id: 0,
      razon: razonSeleccionada!,
      estado: 'Pendiente',
      fecha: fechaSeleccionada!,
      hora: _parseHoraSeleccionada(),
      descripcion: notasController.text.trim(),
      mascotaId: mascotaSeleccionada!.id,
      veterinarioId: veterinarioSeleccionado!.id,
    );

    try {
      await AppointmentService().crearCita(cita);
      SoundService.playSuccess();
      Get.snackbar(
        'Cita creada',
        'La cita ha sido agendada exitosamente.',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
      
      Navigator.pop(context); // opcional: volver a la pantalla anterior
    } catch (e) {
      SoundService.playWarning();
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
    }
  }

  Future<void> actualizarCitaExistente(BuildContext context, String idEvento) async {
    if (!camposObligatoriosLlenos) {
      SoundService.playWarning();
      Get.snackbar(
        'Campos requeridos',
        'Completa todos los campos obligatorios.',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
      return;
    }

    final cita = Cita(
      id: int.parse(idEvento),
      razon: razonSeleccionada!,
      estado: 'Pendiente',
      fecha: fechaSeleccionada!,
      hora: _parseHoraSeleccionada(),
      descripcion: notasController.text.trim().isEmpty ? " " : notasController.text.trim(), //descripcion: notasController.text.trim(),
      mascotaId: mascotaSeleccionada!.id,
      veterinarioId: veterinarioSeleccionado!.id,
    );

    try {
      await AppointmentService().actualizarCita(cita.id, cita);
      SoundService.playSuccess();
      Get.snackbar(
        'Cita actualizada',
        'La cita ha sido reagendada correctamente.',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
      Navigator.pushReplacementNamed(context, '/calendar');
    } catch (e) {
      SoundService.playWarning();
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
    }
  }


  DateTime _parseHoraSeleccionada() {
    final partes = horaSeleccionada!.split(' - ')[0].split(':');
    return DateTime(
      fechaSeleccionada!.year,
      fechaSeleccionada!.month,
      fechaSeleccionada!.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );
  }

  bool get sePuedeMostrarFechaYHora => veterinarioSeleccionado != null;

  bool get camposObligatoriosLlenos =>
      mascotaSeleccionada != null &&
          razonSeleccionada != null &&
          veterinarioSeleccionado != null &&
          fechaSeleccionada != null &&
          horaSeleccionada != null;

  String _nombreDia(int weekday) {
    const dias = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    return dias[weekday - 1];
  }

  bool diaNoLaboral(DateTime dia) {
    final vet = veterinarioSeleccionado;
    if (vet == null) return false;

    final String nombreDia = _nombreDia(dia.weekday);
    final detalle =
    vet.horarios.firstWhereOrNull((h) => h.diaSemana == nombreDia);
    if (detalle == null) return true;

    final horaInicio = DateTime.parse(detalle.horaInicio);
    final horaFin = DateTime.parse(detalle.horaFin);
    return horaInicio == horaFin;
  }

  String? obtenerMotivoExcepcion(DateTime dia) {
    final vet = veterinarioSeleccionado;
    if (vet == null) return null;

    final excepcion = vet.excepciones.firstWhereOrNull((e) {
      if (!e.disponible) {
        final inicio = _combinarFechaHora(e.fecha, e.horaInicio);
        final fin = _combinarFechaHora(e.fecha, e.horaFin);
        return dia.isAfter(inicio.subtract(const Duration(days: 1))) &&
            dia.isBefore(fin.add(const Duration(days: 1))) &&
            _cubreTodoElDia(e, dia);
      }
      return false;
    });

    return excepcion?.motivo;
  }

  List<String> _obtenerHorasDisponiblesParaFecha(
      Veterinario vet,
      DateTime fechaSeleccionada, {
        required List<String> horasOcupadasSimuladas,
      }) {
    final diaNombre = _nombreDia(fechaSeleccionada.weekday);
    final horario = vet.horarios.firstWhereOrNull((h) => h.diaSemana == diaNombre);
    if (horario == null) return [];

    final start = DateTime.parse(horario.horaInicio).hour;
    final end = DateTime.parse(horario.horaFin).hour;
    final bloques = <String>[];

    for (int i = start; i < end; i++) {
      final inicio = '${i.toString().padLeft(2, '0')}:00';
      final fin = '${(i + 1).toString().padLeft(2, '0')}:00';
      if (inicio != '12:00') {
        bloques.add('$inicio - $fin');
      }
    }

    return bloques.where((b) => !horasOcupadasSimuladas.contains(b)).toList();
  }
}


