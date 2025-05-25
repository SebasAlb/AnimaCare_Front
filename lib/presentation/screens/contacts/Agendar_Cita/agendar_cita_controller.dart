import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/contacts/Contact_Principal/contacts_controller.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/presentation/components/list_extensions.dart';


class AgendarCitaController {
  final List<String> mascotas = <String>['Firulais', 'Pelusa', 'Max'];
  final List<String> razones = <String>[
    'Consulta general',
    'Vacunación',
    'Desparasitación',
    'Control postoperatorio',
    'Emergencia',
    'Chequeo geriátrico',
  ];

  final ContactsController contactosController = ContactsController();
  List<String> get veterinariosDisponibles => contactosController.contactos.map((v) => v.nombreCompleto).toList();

  String? mascotaSeleccionada;
  String? razonSeleccionada;
  String? veterinarioSeleccionado;
  DateTime? fechaSeleccionada;
  String? horaSeleccionada;
  final TextEditingController notasController = TextEditingController();

  Future<void> seleccionarFecha(BuildContext context) async {
    final DateTime hoy = DateTime.now();

    // Encuentra el primer día hábil que no esté bloqueado por excepción
    DateTime fechaInicial = hoy;
    while (estaDiaBloqueadoPorExcepcion(fechaInicial) || diaNoLaboral(fechaInicial)) {
      fechaInicial = fechaInicial.add(const Duration(days: 1));
    }


    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 90)),
      selectableDayPredicate: (day) => !estaDiaBloqueadoPorExcepcion(day) && !diaNoLaboral(day),

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
    final vet = contactosController.obtenerVeterinarioPorNombre(veterinarioSeleccionado ?? '');
    if (vet == null) return false;

    return contactosController.excepciones.any((e) =>
      e.veterinarioId == vet.id &&
      !e.disponible &&
      dia.isAfter(e.fechaInicio.subtract(const Duration(days: 1))) &&
      dia.isBefore(e.fechaFin.add(const Duration(days: 1))) &&
      _cubreTodoElDia(e, dia)
    );
  }

  bool _cubreTodoElDia(VeterinarioExcepcion e, DateTime dia) {
    final inicio = DateTime(dia.year, dia.month, dia.day, 0, 0);
    final fin = DateTime(dia.year, dia.month, dia.day, 23, 59);
    return e.fechaInicio.isBefore(inicio) && e.fechaFin.isAfter(fin);
  }

  bool horaBloqueadaPorExcepcion(DateTime fecha, String hora) {
    final vet = contactosController.obtenerVeterinarioPorNombre(veterinarioSeleccionado ?? '');
    if (vet == null) return false;

    final DateTime horaActual = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(hora.split(':')[0]),
    );

    return contactosController.excepciones.any((e) =>
      e.veterinarioId == vet.id &&
      !e.disponible &&
      horaActual.isAfter(e.fechaInicio) &&
      horaActual.isBefore(e.fechaFin)
    );
  }

  Future<void> mostrarSelectorHora(
    BuildContext context,
    VoidCallback refreshUI,
  ) async {
    if (veterinarioSeleccionado == null || fechaSeleccionada == null) return;

    final ThemeData theme = Theme.of(context);

    final List<String> horasDisponibles = contactosController.obtenerHorasDisponiblesParaFecha(
      nombreVeterinario: veterinarioSeleccionado!,
      fechaSeleccionada: fechaSeleccionada!,
      horasOcupadasSimuladas: ['10:00', '12:00'],
    );

    final String nombreDia = _nombreDia(fechaSeleccionada!.weekday);
    final String fechaFormateada = '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}';

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: horasDisponibles.map((String hora) {
                  final bloqueada = horaBloqueadaPorExcepcion(fechaSeleccionada!, hora);
                  return ElevatedButton(
                    onPressed: bloqueada
                        ? null
                        : () {
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


  void confirmarCita(BuildContext context) {
    if (camposObligatoriosLlenos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita agendada exitosamente'),
          backgroundColor: Color(0xFF4B1B3F),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos obligatorios'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
    final vet = contactosController.obtenerVeterinarioPorNombre(veterinarioSeleccionado ?? '');
    if (vet == null) return false;

    final String nombreDia = _nombreDia(dia.weekday); // Ej: "Lunes"
    final horario = vet.horario[nombreDia]?.toLowerCase() ?? '';
    return horario == 'cerrado';
  }

  String? obtenerMotivoExcepcion(DateTime dia) {
  final vet = contactosController.obtenerVeterinarioPorNombre(veterinarioSeleccionado ?? '');
  if (vet == null) return null;

  final excepcion = contactosController.excepciones.firstWhereOrNull(
    (e) =>
        e.veterinarioId == vet.id &&
        !e.disponible &&
        dia.isAfter(e.fechaInicio.subtract(const Duration(days: 1))) &&
        dia.isBefore(e.fechaFin.add(const Duration(days: 1))) &&
        _cubreTodoElDia(e, dia), // ✅ VERIFICA si bloquea todo el día
  );

  return excepcion?.motivo;
}




}
