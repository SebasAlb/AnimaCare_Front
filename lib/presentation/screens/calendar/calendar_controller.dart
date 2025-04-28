import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final focusedDay = DateTime.now().obs;
  final calendarFormat = CalendarFormat.month.obs;

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
    DateTime.utc(2025, 4, 10): [
      {
        'nombre': 'Baño mensual',
        'hora': '11:00 AM',
        'lugar': 'PetSpa Quito',
        'veterinario': 'No aplica',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
        'nombre': 'Revisión dental',
        'hora': '02:00 PM',
        'lugar': 'VetDent Quito',
        'veterinario': 'Dr. Paredes',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
    ],
    DateTime.utc(2025, 6, 15): [
      {
        'nombre': 'Administrar medicamento',
        'hora': '10:30 AM',
        'lugar': 'Clínica AnimalCare',
        'veterinario': 'Dra. Martínez',
        'mascota': 'Firulais',
        'anticipacion': '1 día antes',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'En app y celular',
      },
      {
        'nombre': 'Vacuna contra parásitos',
        'hora': '12:00 PM',
        'lugar': 'Clínica AnimalCare',
        'veterinario': 'Dra. Martínez',
        'mascota': 'Firulais',
        'anticipacion': '1 día',
        'frecuencia': 'Cada 6 horas',
        'recibirRecordatorio': 'No recibir',
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
    focusedDay.value = DateTime(focusedDay.value.year, mes, focusedDay.value.day);
  }

  void cambiarAnio(int anio) {
    focusedDay.value = DateTime(anio, focusedDay.value.month, focusedDay.value.day);
  }

  /// Obtiene el color basado en el nombre del evento
  Color obtenerColorEvento(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('baño')) return Colors.blue;
    if (lower.contains('veterinario') || lower.contains('consulta')) return Colors.green;
    if (lower.contains('medicina') || lower.contains('medicamento')) return Colors.yellow.shade700;
    if (lower.contains('vacuna')) return Colors.lightBlueAccent;
    return Colors.purple;
  }

  /// Obtiene el ícono basado en el nombre del evento
  IconData obtenerIconoEvento(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('baño')) return Icons.shower;
    if (lower.contains('veterinario') || lower.contains('consulta')) return Icons.local_hospital;
    if (lower.contains('medicina') || lower.contains('medicamento')) return Icons.medical_services;
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
}
