import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final focusedDay = DateTime.now().obs;
  final calendarFormat = CalendarFormat.month.obs;

  final modoEventos = false.obs; //  Modo Eventos o Modo Calendario
  final searchQuery = ''.obs; //  Texto para buscar eventos

  final eventos = <DateTime, List<Map<String, String>>>{
    DateTime.utc(2025, 4, 5): [
      {
        'nombre': 'Vacuna antirrábica',
        'hora': '09:00 AM',
        'lugar': 'Clínica VetCare',
        'veterinario': 'Dr. Salazar',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
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
    DateTime.utc(2025, 4, 6): [
      {
        'nombre': 'Consulta veterinaria',
        'hora': '10:00 AM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
        'nombre': 'Entrega de medicina',
        'hora': '01:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
        'nombre': 'Desparasitación',
        'hora': '02:30 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
        'nombre': 'Revisión médica extra',
        'hora': '04:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
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

  List<Map<String, String>> obtenerEventosPorDia(DateTime dia) {
    return eventos[dia] ?? [];
  }

  bool isDayLoaded(DateTime dia) {
    return obtenerEventosPorDia(dia).length > 4;
  }

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
    final lower = nombre.toLowerCase();
    if (lower.contains('baño')) return Colors.blue;
    if (lower.contains('veterinario') || lower.contains('consulta'))
      return Colors.green;
    if (lower.contains('medicina') || lower.contains('medicamento'))
      return Colors.yellow.shade700;
    if (lower.contains('vacuna')) return Colors.lightBlueAccent;
    return Colors.purple;
  }

  /// Obtiene el ícono basado en el nombre del evento
  IconData obtenerIconoEvento(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('baño')) return Icons.shower;
    if (lower.contains('veterinario') || lower.contains('consulta'))
      return Icons.local_hospital;
    if (lower.contains('medicina') || lower.contains('medicamento'))
      return Icons.medical_services;
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
    final nuevoEvento = {
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
      eventos[fecha] = [nuevoEvento];
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
    List<Map<String, dynamic>> resultados = [];

    eventos.forEach((fecha, listaEventos) {
      for (var evento in listaEventos) {
        final nombre = evento['nombre']?.toLowerCase() ?? '';
        final veterinario = evento['veterinario']?.toLowerCase() ?? '';
        final mascota = evento['mascota']?.toLowerCase() ?? '';

        if (searchQuery.value.isEmpty ||
            nombre.contains(searchQuery.value.toLowerCase()) ||
            veterinario.contains(searchQuery.value.toLowerCase()) ||
            mascota.contains(searchQuery.value.toLowerCase())) {
          resultados.add({
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
