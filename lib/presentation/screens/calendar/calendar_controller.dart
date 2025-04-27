import 'package:get/get.dart';
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
        'veterinario': 'Dr. Salazar'
      },
      {
        'nombre': 'Baño programado',
        'hora': '03:00 PM',
        'lugar': 'PetSpa Quito',
        'veterinario': 'No aplica'
      },
    ],
    DateTime.utc(2025, 4, 6): [
      {
        'nombre': 'Consulta veterinaria',
        'hora': '10:00 AM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González'
      },
      {
        'nombre': 'Entrega de medicina',
        'hora': '01:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González'
      },
      {
        'nombre': 'Desparasitación',
        'hora': '02:30 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González'
      },
      {
        'nombre': 'Revisión médica extra',
        'hora': '04:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González'
      },
      {
        'nombre': 'Aplicar tratamiento especial',
        'hora': '06:00 PM',
        'lugar': 'AnimalMed Center',
        'veterinario': 'Dra. González'
      },
    ],
    DateTime.utc(2025, 4, 10): [
      {
        'nombre': 'Baño mensual',
        'hora': '11:00 AM',
        'lugar': 'PetSpa Quito',
        'veterinario': 'No aplica'
      },
      {
        'nombre': 'Revisión dental',
        'hora': '02:00 PM',
        'lugar': 'VetDent Quito',
        'veterinario': 'Dr. Paredes'
      },
    ],
    DateTime.utc(2025, 6, 15): [
      {
        'nombre': 'Administrar medicamento',
        'hora': '10:30 AM',
        'lugar': 'Clínica AnimalCare',
        'veterinario': 'Dra. Martínez'
      },
      {
        'nombre': 'Vacuna contra parásitos',
        'hora': '12:00 PM',
        'lugar': 'Clínica AnimalCare',
        'veterinario': 'Dra. Martínez'
      },
    ],
  }.obs;

  // Adaptado para devolver lista de Map
  List<Map<String, String>> obtenerEventosPorDia(DateTime dia) {
    return eventos[dia] ?? [];
  }

  // Detectar si el día tiene muchos eventos (más de 4)
  bool isDayLoaded(DateTime dia) {
    return obtenerEventosPorDia(dia).length > 4;
  }

  // Cambiar mes
  void cambiarMes(int mes) {
    focusedDay.value = DateTime(focusedDay.value.year, mes, focusedDay.value.day);
  }

  // Cambiar año
  void cambiarAnio(int anio) {
    focusedDay.value = DateTime(anio, focusedDay.value.month, focusedDay.value.day);
  }
}