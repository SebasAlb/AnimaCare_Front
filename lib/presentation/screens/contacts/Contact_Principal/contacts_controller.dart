import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_horario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contacto_Detalle/contact_info_screen.dart';

import 'package:animacare_front/presentation/components/list_extensions.dart';

class ContactsController {
  
  final List<Veterinario> contactos = [
    Veterinario(
      id: '1',
      nombre: 'Ana',
      apellido: 'Andrade',
      cedulaProfesional: 'VET123456',
      telefono: '+593 987 654 321',
      correo: 'lucia@vetcare.ec',
      rol: 'Consulta general',
      fechaIngreso: DateTime(2015, 3, 10),
      fotoUrl: '',
      estado: 'Disponible',
      horario: {
        'Lunes': '08:00 - 16:00',
        'Martes': '08:00 - 16:00',
        'Miércoles': '10:00 - 20:00',
        'Jueves': '08:00 - 16:00',
        'Viernes': '08:00 - 16:00',
        'Sábado': '09:00 - 14:00',
        'Domingo': 'Cerrado',
      },
      horariosDetalle: [
        VeterinarioHorario(veterinarioId: '1', diaSemana: 'Lunes', horaInicio: '08:00', horaFin: '16:00'),
        VeterinarioHorario(veterinarioId: '1', diaSemana: 'Martes', horaInicio: '08:00', horaFin: '16:00'),
        VeterinarioHorario(veterinarioId: '1', diaSemana: 'Miércoles', horaInicio: '10:00', horaFin: '20:00'),
        VeterinarioHorario(veterinarioId: '1', diaSemana: 'Jueves', horaInicio: '08:00', horaFin: '16:00'),
        VeterinarioHorario(veterinarioId: '1', diaSemana: 'Viernes', horaInicio: '08:00', horaFin: '16:00'),
        VeterinarioHorario(veterinarioId: '1', diaSemana: 'Sábado', horaInicio: '09:00', horaFin: '14:00'),
      ],
    ),
    Veterinario(
      id: '2',
      nombre: 'Mario',
      apellido: 'Paz',
      cedulaProfesional: 'VET987654',
      telefono: '+593 999 888 777',
      correo: 'mario@vetcare.ec',
      rol: 'Cirujano',
      fechaIngreso: DateTime(2018, 6, 5),
      fotoUrl: '',
      estado: 'Disponible',
      horario: {
        'Lunes': '08:00 - 14:00',
        'Martes': '08:00 - 14:00',
        'Miércoles': '08:00 - 14:00',
        'Jueves': '08:00 - 14:00',
        'Viernes': '08:00 - 14:00',
        'Sábado': 'Cerrado',
        'Domingo': 'Cerrado',
      },
      horariosDetalle: [
        VeterinarioHorario(veterinarioId: '2', diaSemana: 'Lunes', horaInicio: '08:00', horaFin: '14:00'),
        VeterinarioHorario(veterinarioId: '2', diaSemana: 'Martes', horaInicio: '08:00', horaFin: '14:00'),
        VeterinarioHorario(veterinarioId: '2', diaSemana: 'Miércoles', horaInicio: '08:00', horaFin: '14:00'),
        VeterinarioHorario(veterinarioId: '2', diaSemana: 'Jueves', horaInicio: '08:00', horaFin: '14:00'),
        VeterinarioHorario(veterinarioId: '2', diaSemana: 'Viernes', horaInicio: '08:00', horaFin: '14:00'),
      ],
    ),
    Veterinario(
      id: '3',
      nombre: 'Esteban',
      apellido: 'Ortega',
      cedulaProfesional: 'VET246810',
      telefono: '0 111 223 344',
      correo: 'esteban@vetcare.ec',
      rol: 'Emergencias',
      fechaIngreso: DateTime(2020, 1, 12),
      fotoUrl: '',
      estado: 'Disponible',
      horario: {
        'Lunes': '10:00 - 20:00',
        'Martes': '10:00 - 18:00',
        'Miércoles': '10:00 - 18:00',
        'Jueves': '10:00 - 18:00',
        'Viernes': '10:00 - 18:00',
        'Sábado': 'Cerrado',
        'Domingo': 'Cerrado',
      },
      horariosDetalle: [
        VeterinarioHorario(veterinarioId: '3', diaSemana: 'Lunes', horaInicio: '10:00', horaFin: '18:00'),
        VeterinarioHorario(veterinarioId: '3', diaSemana: 'Martes', horaInicio: '10:00', horaFin: '18:00'),
        VeterinarioHorario(veterinarioId: '3', diaSemana: 'Miércoles', horaInicio: '10:00', horaFin: '18:00'),
        VeterinarioHorario(veterinarioId: '3', diaSemana: 'Jueves', horaInicio: '10:00', horaFin: '18:00'),
        VeterinarioHorario(veterinarioId: '3', diaSemana: 'Viernes', horaInicio: '10:00', horaFin: '18:00'),
      ],
    ),
  ];

  /// Excepciones aplicables: se evalúan en tiempo real según fecha/hora actual
  final List<VeterinarioExcepcion> excepciones = [
    VeterinarioExcepcion(
      veterinarioId: '2',
      fechaInicio: DateTime.now().subtract(const Duration(days: 1)),
      fechaFin: DateTime.now().add(const Duration(days: 4)),
      motivo: 'Vacaciones',
      disponible: false,
    ),
    VeterinarioExcepcion(
      veterinarioId: '3', // o el ID del veterinario que quieras
      fechaInicio: DateTime(2025, 5, 26, 8), // 26 de mayo a las 08:00
      fechaFin: DateTime(2025, 5, 26, 12),   // 26 de mayo a las 12:00
      motivo: 'Capacitación interna',
      disponible: false,
    ),
  ];

  void abrirDetalle(BuildContext context, Veterinario veterinario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactInfoScreen(
          veterinario: veterinario,
          excepciones: excepciones, // <-- Excepciones definidas en el controller
        ),
      ),
    );
  }


  void abrirAgendarCita(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AgendarCitaScreen()),
    );
  }

  Veterinario? obtenerVeterinarioPorNombre(String nombreCompleto) {
    return contactos.firstWhereOrNull((v) => v.nombreCompleto == nombreCompleto);
  }
  
  List<String> obtenerHorasDisponiblesParaFecha({
    required String nombreVeterinario,
    required DateTime fechaSeleccionada,
    required List<String> horasOcupadasSimuladas,
  }) {
    final vet = obtenerVeterinarioPorNombre(nombreVeterinario);
    if (vet == null) return [];

    final diaNombre = _nombreDia(fechaSeleccionada.weekday);

    final horario = vet.horariosDetalle?.firstWhereOrNull(
      (h) => h.diaSemana == diaNombre,
    );
    if (horario == null) return [];

    final bloques = _generarBloquesHorario(horario.horaInicio, horario.horaFin);

    // Devuelve todos los bloques excepto los ocupados simulados
    return bloques.where((bloque) => !horasOcupadasSimuladas.contains(bloque)).toList();
  }


  String _nombreDia(int weekday) {
    const dias = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    return dias[weekday - 1];
  }

  
  List<String> _generarBloquesHorario(String horaInicio, String horaFin) {
    final int start = int.parse(horaInicio.split(':')[0]);
    final int end = int.parse(horaFin.split(':')[0]);

    final List<String> bloques = [];

    for (int i = start; i < end; i++) {
      final String bloqueInicio = '${i.toString().padLeft(2, '0')}:00';
      final String bloqueFin = '${(i + 1).toString().padLeft(2, '0')}:00';

      // Excluir el bloque que incluye 12:00 (almuerzo)
      if (bloqueInicio != '12:00') {
        bloques.add('$bloqueInicio - $bloqueFin');
      }
    }

    return bloques;
  }

}

