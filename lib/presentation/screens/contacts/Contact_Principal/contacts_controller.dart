import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/services/veterinarian_service.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contacto_Detalle/contact_info_screen.dart';
import 'package:animacare_front/presentation/components/list_extensions.dart';
import 'package:animacare_front/storage/veterinarian_storage.dart'; // IMPORTANTE

class ContactsController {
  final List<Veterinario> contactos = [];
  final List<VeterinarioExcepcion> excepciones = [];

  final VeterinarianService _service = VeterinarianService();

  Future<void> cargarVeterinarios() async {
    if (VeterinariosStorage.hasVeterinarios()) {
      final almacenados = VeterinariosStorage.getVeterinarios();
      contactos.clear();
      contactos.addAll(almacenados);

      excepciones.clear();
      for (var vet in almacenados) {
        excepciones.addAll(vet.excepciones);
      }

      return;
    }

    // Si no están guardados, obténlos del backend y guárdalos
    final data = await _service.fetchVeterinarios();
    contactos.clear();
    contactos.addAll(data);

    excepciones.clear();
    for (var vet in data) {
      excepciones.addAll(vet.excepciones);
    }

    VeterinariosStorage.saveVeterinarios(data);
  }

  void abrirDetalle(BuildContext context, Veterinario veterinario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactInfoScreen(
          veterinario: veterinario,
          excepciones: excepciones,
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

    final horario = vet.horarios?.firstWhereOrNull(
          (h) => h.diaSemana == diaNombre,
    );
    if (horario == null) return [];

    final bloques = _generarBloquesHorario(horario.horaInicio, horario.horaFin);
    return bloques.where((bloque) => !horasOcupadasSimuladas.contains(bloque)).toList();
  }

  String _nombreDia(int weekday) {
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return dias[weekday - 1];
  }

  List<String> _generarBloquesHorario(String horaInicio, String horaFin) {
    final int start = int.parse(horaInicio.split(':')[0]);
    final int end = int.parse(horaFin.split(':')[0]);

    final List<String> bloques = [];
    for (int i = start; i < end; i++) {
      final String bloqueInicio = '${i.toString().padLeft(2, '0')}:00';
      final String bloqueFin = '${(i + 1).toString().padLeft(2, '0')}:00';
      if (bloqueInicio != '12:00') {
        bloques.add('$bloqueInicio - $bloqueFin');
      }
    }
    return bloques;
  }
}
