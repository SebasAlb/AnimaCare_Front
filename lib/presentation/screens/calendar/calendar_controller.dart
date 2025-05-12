import 'package:flutter/material.dart';

class CalendarController {
  final TextEditingController searchController = TextEditingController();
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool modoCalendario = true;

  final List<Map<String, dynamic>> eventos = <Map<String, dynamic>>[
    <String, dynamic>{
      'titulo': 'Vacuna contra la rabia',
      'hora': '11:44',
      'mascota': 'Firulais',
      'veterinario': 'Dr. González',
      'fecha': '2025-05-10',
      'tipo': 'Cita',
      'esCita': true,
    },
    <String, dynamic>{
      'titulo': 'Control general',
      'hora': '15:30',
      'mascota': 'Pelusa',
      'veterinario': 'Dra. Ramírez',
      'fecha': '2025-05-10',
      'tipo': 'Cita',
      'esCita': true,
    },
    <String, dynamic>{
      'titulo': 'Charla de adopción',
      'hora': '12:00',
      'mascota': 'General',
      'veterinario': 'Equipo Fundación Patitas',
      'fecha': '2025-05-10',
      'tipo': 'Charla',
      'esCita': false,
    },
    <String, dynamic>{
      'titulo': 'Revisión dental',
      'hora': '09:00',
      'mascota': 'Kira',
      'veterinario': 'Dr. Villalba',
      'fecha': '2025-05-11',
      'tipo': 'Cita',
      'esCita': true,
    },
    <String, dynamic>{
      'titulo': 'Conferencia bienestar animal',
      'hora': '17:00',
      'mascota': 'Todos',
      'veterinario': 'Invitados internacionales',
      'fecha': '2025-05-12',
      'tipo': 'Conferencia',
      'esCita': false,
    },
  ];

  void cambiarModo(bool nuevoModo, VoidCallback actualizarUI) {
    modoCalendario = nuevoModo;
    actualizarUI();
  }

  void seleccionarDia(
      DateTime selected, DateTime focused, VoidCallback actualizarUI,) {
    selectedDay = selected;
    focusedDay = focused;
    actualizarUI();
  }

  List<Map<String, dynamic>> filtrarEventosPorTexto() {
    final String filtro = searchController.text.toLowerCase();
    return eventos.where((e) => e['titulo'].toLowerCase().contains(filtro) ||
          e['mascota'].toLowerCase().contains(filtro),).toList();
  }

  List<Map<String, dynamic>> eventosDelDia(DateTime? dia) {
    if (dia == null) return <Map<String, dynamic>>[];
    final String formato = '${dia.year}-${_dos(dia.month)}-${_dos(dia.day)}';
    return eventos.where((e) => e['fecha'] == formato).toList();
  }

  String _dos(int n) => n.toString().padLeft(2, '0');
}
