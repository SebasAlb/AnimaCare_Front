import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class CalendarController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool modoCalendario = true;

  /// Lista de eventos tipados
  final List<EventoCalendar> _eventos = <EventoCalendar>[
    EventoCalendar(
      id: '1',
      titulo: 'Vacuna contra la rabia',
      hora: '11:44',
      mascota: 'Firulais',
      veterinario: 'Dr. González',
      fecha: '2025-05-10',
      tipo: 'cita',
      categoria: 'Vacuna',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '2',
      titulo: 'Control general',
      hora: '15:30',
      mascota: 'Pelusa',
      veterinario: 'Dra. Ramírez',
      fecha: '2025-05-10',
      tipo: 'cita',
      categoria: 'Consulta',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '3',
      titulo: 'Charla de adopción',
      hora: '12:00',
      mascota: 'General',
      veterinario: 'Equipo Fundación Patitas',
      fecha: '2025-05-10',
      tipo: 'evento',
      categoria: 'Charla',
    ),
    EventoCalendar(
      id: '4',
      titulo: 'Revisión dental',
      hora: '09:00',
      mascota: 'Kira',
      veterinario: 'Dr. Villalba',
      fecha: '2025-05-11',
      tipo: 'cita',
      categoria: 'Odontología',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '5',
      titulo: 'Conferencia bienestar animal',
      hora: '17:00',
      mascota: 'Todos',
      veterinario: 'Invitados internacionales',
      fecha: '2025-05-12',
      tipo: 'evento',
      categoria: 'Conferencia',
    ),
    EventoCalendar(
      id: '6',
      titulo: 'Vacunación múltiple',
      hora: '08:00',
      mascota: 'Max',
      veterinario: 'Dr. Torres',
      fecha: '2025-05-12',
      tipo: 'cita',
      categoria: 'Vacuna',
      estado: 'pendiente',
    ),
  ];

  List<EventoCalendar> get eventos => _eventos;

  /// Cambia entre modo calendario y modo eventos
  void cambiarModo(bool nuevoModo) {
    modoCalendario = nuevoModo;
    notifyListeners();
  }

  /// Selecciona el día actual y enfoca el calendario
  void seleccionarDia(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }

  /// Devuelve los eventos del día seleccionado
  List<EventoCalendar> eventosDelDia(DateTime? dia) {
    if (dia == null) return <EventoCalendar>[];
    final String formato = _formatoFecha(dia);
    return _eventos.where((e) => e.fecha == formato).toList();
  }

  /// Filtra eventos por texto del buscador
  List<EventoCalendar> filtrarEventosPorTexto() {
    final String filtro = searchController.text.toLowerCase();
    return _eventos
        .where((e) =>
            e.titulo.toLowerCase().contains(filtro) ||
            e.mascota.toLowerCase().contains(filtro),)
        .toList();
  }

  /// Obtiene los días con eventos para marcarlos en el calendario
  Map<DateTime, List<EventoCalendar>> getDiasConEventos() {
    final Map<DateTime, List<EventoCalendar>> mapa = <DateTime, List<EventoCalendar>>{};
    for (final EventoCalendar evento in _eventos) {
      final DateTime fecha = DateTime.parse(evento.fecha);
      mapa.putIfAbsent(fecha, () => <EventoCalendar>[]).add(evento);
    }
    return mapa;
  }

  /// Carga inicial de eventos (por ahora estática, futura: desde backend)
  void cargarEventosIniciales() {
    // Aquí podrías hacer una petición HTTP al backend:
    /*
    Future<void> fetchEventos() async {
      final response = await http.get(Uri.parse('https://api.tuveterinaria.com/eventos'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        _eventos = data.map((e) => EventoCalendar.fromJson(e)).toList();
        notifyListeners();
      } else {
        throw Exception('Error al cargar eventos');
      }
    }
    */
    notifyListeners(); // Refresca la UI tras la carga inicial (simulada)
  }

  /// Formatea fecha a yyyy-MM-dd
  String _formatoFecha(DateTime fecha) =>
      '${fecha.year}-${_dos(fecha.month)}-${_dos(fecha.day)}';

  String _dos(int n) => n.toString().padLeft(2, '0');
}
