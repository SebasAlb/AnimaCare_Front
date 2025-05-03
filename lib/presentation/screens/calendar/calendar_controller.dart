import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;

  final RxBool modoEventos = false.obs; //  Modo Eventos o Modo Calendario
  final RxString searchQuery = ''.obs; //  Texto para buscar eventos

  final RxMap<DateTime, List<Map<String, String>>> eventos =
      <DateTime, List<Map<String, String>>>{
    DateTime.utc(2025, 4, 5): <Map<String, String>>[
      <String, String>{
        'nombre': 'Vacuna antirrábica',
        'hora': '09:00 AM',
        'lugar': 'Clínica VetCare',
        'veterinario': 'Dr. Salazar',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      <String, String>{
        'nombre': 'Baño programado',
        'hora': '03:00 PM',
        'lugar': 'PetSpa Quito',
        'veterinario': 'No aplica',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
    ],
    DateTime.utc(2025, 4, 6): <Map<String, String>>[
      <String, String>{
        'nombre': 'Consulta veterinaria',
        'hora': '10:00 AM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      <String, String>{
        'nombre': 'Entrega de medicina',
        'hora': '01:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      <String, String>{
        'nombre': 'Desparasitación',
        'hora': '02:30 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      <String, String>{
        'nombre': 'Revisión médica extra',
        'hora': '04:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      <String, String>{
        'nombre': 'Aplicar tratamiento especial',
        'hora': '06:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
    ],
  }.obs;

  List<Map<String, String>> obtenerEventosPorDia(DateTime dia) =>
      eventos[dia] ?? <Map<String, String>>[];

  bool isDayLoaded(DateTime dia) => obtenerEventosPorDia(dia).length > 4;

  void cambiarMes(int mes) {
    focusedDay.value =
        DateTime(focusedDay.value.year, mes, focusedDay.value.day);
  }

  void cambiarAnio(int anio) {
    focusedDay.value =
        DateTime(anio, focusedDay.value.month, focusedDay.value.day);
  }

  /// Obtiene el color basado en el nombre del evento
  Color obtenerColorEvento(String nombre) {
    final String lower = nombre.toLowerCase();
    if (lower.contains('baño')) return Colors.blue;
    if (lower.contains('veterinario') || lower.contains('consulta')) {
      return Colors.green;
    }
    if (lower.contains('medicina') || lower.contains('medicamento')) {
      return Colors.yellow.shade700;
    }
    if (lower.contains('vacuna')) return Colors.lightBlueAccent;
    return Colors.purple;
  }

  /// Obtiene el ícono basado en el nombre del evento
  IconData obtenerIconoEvento(String nombre) {
    final String lower = nombre.toLowerCase();
    if (lower.contains('baño')) return Icons.shower;
    if (lower.contains('veterinario') || lower.contains('consulta')) {
      return Icons.local_hospital;
    }
    if (lower.contains('medicina') || lower.contains('medicamento')) {
      return Icons.medical_services;
    }
    if (lower.contains('vacuna')) return Icons.vaccines;
    return Icons.pets;
  }

  /// Agrega un nuevo evento con toda la información
  void agregarEvento({
    required DateTime fecha,
    required String nombre,
    required String hora,
    required String lugar,
    required String veterinario,
    required String mascota,
    required String anticipacion,
    required String frecuencia,
    required String recibirRecordatorio,
  }) {
    final Map<String, String> nuevoEvento = <String, String>{
      'nombre': nombre,
      'hora': hora,
      'lugar': lugar,
      'veterinario': veterinario,
      'mascota': mascota,
      'anticipacion': anticipacion,
      'frecuencia': frecuencia,
      'recibirRecordatorio': recibirRecordatorio,
    };

    if (eventos.containsKey(fecha)) {
      eventos[fecha]!.add(nuevoEvento);
    } else {
      eventos[fecha] = <Map<String, String>>[nuevoEvento];
    }
    eventos.refresh();
  }

  /// Elimina un evento (por índice en la lista del día)
  void eliminarEvento(DateTime fecha, int index) {
    if (eventos.containsKey(fecha)) {
      eventos[fecha]!.removeAt(index);
      if (eventos[fecha]!.isEmpty) {
        eventos.remove(fecha); // si ya no hay eventos ese día, elimino el día
      }
    }
  }

  // 🔥 FUNCIONES NUEVAS 🔥

  void toggleModoEventos() {
    modoEventos.value = !modoEventos.value;

    // Si entramos en modo eventos, aseguramos que el formato sea 2 semanas
    if (modoEventos.value) {
      calendarFormat.value = CalendarFormat.twoWeeks; // Cambiar a 2 semanas
    }

    // El formato no cambia al salir del modo eventos, se mantiene en 2 semanas
  }

  void filtrarEventos(String query) {
    searchQuery.value = query;
  }

  List<Map<String, dynamic>> get eventosFiltrados {
    final List<Map<String, dynamic>> resultados = <Map<String, dynamic>>[];

    eventos.forEach((fecha, listaEventos) {
      for (final Map<String, String> evento in listaEventos) {
        final String nombre = evento['nombre']?.toLowerCase() ?? '';
        final String veterinario = evento['veterinario']?.toLowerCase() ?? '';
        final String mascota = evento['mascota']?.toLowerCase() ?? '';

        if (searchQuery.value.isEmpty ||
            nombre.contains(searchQuery.value.toLowerCase()) ||
            veterinario.contains(searchQuery.value.toLowerCase()) ||
            mascota.contains(searchQuery.value.toLowerCase())) {
          resultados.add(<String, dynamic>{
            'fecha': fecha,
            'evento': evento,
          });
        }
      }
    });

    // Ordenar por fecha
    resultados.sort((a, b) => a['fecha'].compareTo(b['fecha']));

    return resultados;
  }
}
