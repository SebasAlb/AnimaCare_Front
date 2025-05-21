import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class CalendarController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool modoCalendario = true;

  // Filtros avanzados
  Map<String, dynamic> filtrosAvanzados = <String, dynamic>{
    'mascota': null,
    'veterinario': null,
    'tipo': null,
    'categoria': null,
    'fechaDesde': null,
    'fechaHasta': null,
    'horaDesde': null,
    'horaHasta': null,
  };

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
    EventoCalendar(
      id: '7',
      titulo: 'Chequeo general',
      hora: '09:00',
      mascota: 'Luna',
      veterinario: 'Dra. Espinoza',
      fecha: '2025-05-12',
      tipo: 'cita',
      categoria: 'Consulta',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '8',
      titulo: 'Taller de cuidado animal',
      hora: '11:00',
      mascota: 'General',
      veterinario: 'Fundación Patitas',
      fecha: '2025-05-12',
      tipo: 'evento',
      categoria: 'Charla',
    ),
    EventoCalendar(
      id: '9',
      titulo: 'Control dermatológico',
      hora: '14:00',
      mascota: 'Rocky',
      veterinario: 'Dr. Pérez',
      fecha: '2025-05-12',
      tipo: 'cita',
      categoria: 'Dermatología',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '10',
      titulo: 'Sesión informativa de adopción',
      hora: '16:00',
      mascota: 'Todos',
      veterinario: 'Voluntariado Animal',
      fecha: '2025-05-12',
      tipo: 'evento',
      categoria: 'Charla',
    ),
    EventoCalendar(
      id: '11',
      titulo: 'Vacuna antirrábica',
      hora: '09:30',
      mascota: 'Sasha',
      veterinario: 'Dra. Guzmán',
      fecha: '2025-05-14',
      tipo: 'cita',
      categoria: 'Vacuna',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '12',
      titulo: 'Evaluación nutricional',
      hora: '11:15',
      mascota: 'Milo',
      veterinario: 'Dr. Herrera',
      fecha: '2025-05-14',
      tipo: 'cita',
      categoria: 'Consulta',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '13',
      titulo: 'Charla sobre tenencia responsable',
      hora: '13:00',
      mascota: 'General',
      veterinario: 'FAUNA Ecuador',
      fecha: '2025-05-14',
      tipo: 'evento',
      categoria: 'Charla',
    ),
    EventoCalendar(
      id: '14',
      titulo: 'Control cardiaco',
      hora: '15:30',
      mascota: 'Zoe',
      veterinario: 'Dra. Villamar',
      fecha: '2025-05-14',
      tipo: 'cita',
      categoria: 'Cardiología',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '15',
      titulo: 'Cita de revisión anual',
      hora: '17:00',
      mascota: 'Toby',
      veterinario: 'Dr. Romero',
      fecha: '2025-05-14',
      tipo: 'cita',
      categoria: 'Control',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '16',
      titulo: 'Revisión post-operatoria',
      hora: '08:00',
      mascota: 'Nina',
      veterinario: 'Dra. Quintero',
      fecha: '2025-05-16',
      tipo: 'cita',
      categoria: 'Cirugía',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '17',
      titulo: 'Conferencia de salud animal',
      hora: '10:00',
      mascota: 'Todos',
      veterinario: 'Invitados especiales',
      fecha: '2025-05-16',
      tipo: 'evento',
      categoria: 'Conferencia',
    ),
    EventoCalendar(
      id: '18',
      titulo: 'Vacunación canina',
      hora: '12:00',
      mascota: 'Simba',
      veterinario: 'Dr. Gómez',
      fecha: '2025-05-16',
      tipo: 'cita',
      categoria: 'Vacuna',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '19',
      titulo: 'Charla para nuevos dueños',
      hora: '14:30',
      mascota: 'General',
      veterinario: 'Refugio Animal',
      fecha: '2025-05-16',
      tipo: 'evento',
      categoria: 'Charla',
    ),
    EventoCalendar(
      id: '20',
      titulo: 'Cita de control digestivo',
      hora: '16:00',
      mascota: 'Pancho',
      veterinario: 'Dra. Ledesma',
      fecha: '2025-05-16',
      tipo: 'cita',
      categoria: 'Gastroenterología',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '21',
      titulo: 'Revisión de piel',
      hora: '09:00',
      mascota: 'Bella',
      veterinario: 'Dra. Torres',
      fecha: '2025-05-20',
      tipo: 'cita',
      categoria: 'Dermatología',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '22',
      titulo: 'Charla de prevención',
      hora: '10:30',
      mascota: 'Todos',
      veterinario: 'Fundación Huellitas',
      fecha: '2025-05-20',
      tipo: 'evento',
      categoria: 'Charla',
    ),
    EventoCalendar(
      id: '23',
      titulo: 'Cita de fisioterapia',
      hora: '13:00',
      mascota: 'Rex',
      veterinario: 'Dr. Navarro',
      fecha: '2025-05-20',
      tipo: 'cita',
      categoria: 'Rehabilitación',
      estado: 'pendiente',
    ),
    EventoCalendar(
      id: '24',
      titulo: 'Jornada de vacunación',
      hora: '15:00',
      mascota: 'Loki',
      veterinario: 'Dra. Viteri',
      fecha: '2025-05-20',
      tipo: 'cita',
      categoria: 'Vacuna',
      estado: 'confirmada',
    ),
    EventoCalendar(
      id: '25',
      titulo: 'Conferencia internacional sobre salud',
      hora: '17:30',
      mascota: 'Todos',
      veterinario: 'FAUNA GLOBAL',
      fecha: '2025-05-20',
      tipo: 'evento',
      categoria: 'Conferencia',
    ),
  ];

  List<EventoCalendar> get eventos => _eventos;

  void cambiarModo(bool nuevoModo) {
    modoCalendario = nuevoModo;
    notifyListeners();
  }

  void seleccionarDia(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }

  List<EventoCalendar> eventosDelDia(DateTime? dia) {
    if (dia == null) return <EventoCalendar>[];
    final String formato = _formatoFecha(dia);
    return _eventos.where((e) => e.fecha == formato).toList();
  }

  List<EventoCalendar> filtrarEventosPorTexto() {
    final String texto = searchController.text.toLowerCase().trim();

    return _eventos.where((evento) {
      // Texto
      final bool coincideTexto = texto.isEmpty ||
          evento.titulo.toLowerCase().contains(texto) ||
          evento.mascota.toLowerCase().contains(texto) ||
          evento.veterinario.toLowerCase().contains(texto) ||
          evento.fecha.contains(texto) ||
          evento.fecha.replaceAll('-', '/').contains(texto) ||
          evento.fecha.replaceAll('-', '').contains(texto);

      // Filtros avanzados
      final m = filtrosAvanzados['mascota'];
      final v = filtrosAvanzados['veterinario'];
      final t = filtrosAvanzados['tipo'];
      final c = filtrosAvanzados['categoria'];
      final fd = filtrosAvanzados['fechaDesde'];
      final fh = filtrosAvanzados['fechaHasta'];
      final hd = filtrosAvanzados['horaDesde'];
      final hh = filtrosAvanzados['horaHasta'];

      final bool coincideMascota = m == null || evento.mascota == m;
      final bool coincideVeterinario = v == null || evento.veterinario == v;
      final bool coincideTipo = t == null || evento.tipo == t;
      final bool coincideCategoria = c == null || evento.categoria == c;

      final DateTime? fechaEvento = DateTime.tryParse(evento.fecha);
      final bool coincideFecha = (fd == null ||
              (fechaEvento != null &&
                  fechaEvento.isAfter(fd.subtract(const Duration(days: 1))))) &&
          (fh == null ||
              (fechaEvento != null &&
                  fechaEvento.isBefore(fh.add(const Duration(days: 1)))));

      final List<String> horaPartes = evento.hora.split(':');
      final TimeOfDay horaEvento = TimeOfDay(
        hour: int.parse(horaPartes[0]),
        minute: int.parse(horaPartes[1]),
      );
      bool horaPosterior(TimeOfDay a, TimeOfDay b) =>
          a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);
      bool horaAnterior(TimeOfDay a, TimeOfDay b) =>
          a.hour < b.hour || (a.hour == b.hour && a.minute <= b.minute);
      final bool coincideHora = (hd == null || horaPosterior(horaEvento, hd)) &&
          (hh == null || horaAnterior(horaEvento, hh));

      return coincideTexto &&
          coincideMascota &&
          coincideVeterinario &&
          coincideTipo &&
          coincideCategoria &&
          coincideFecha &&
          coincideHora;
    }).toList();
  }

  void aplicarFiltrosAvanzados(Map<String, dynamic> nuevosFiltros) {
    filtrosAvanzados = nuevosFiltros;
    notifyListeners();
  }

  Map<DateTime, List<EventoCalendar>> getDiasConEventos() {
    final Map<DateTime, List<EventoCalendar>> mapa =
        <DateTime, List<EventoCalendar>>{};
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

  String _formatoFecha(DateTime fecha) =>
      '${fecha.year}-${_dos(fecha.month)}-${_dos(fecha.day)}';

  String _dos(int n) => n.toString().padLeft(2, '0');
}
