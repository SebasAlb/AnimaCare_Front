import 'package:animacare_front/storage/pet_storage.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';
import 'package:animacare_front/services/pet_service.dart';

class CalendarController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final PetService _petService = PetService();

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool modoCalendario = true;

  Map<String, dynamic> filtrosAvanzados = <String, dynamic>{
    'mascota': null,
    'veterinario': null,
    'tipo': null,
    'categoria': null,
    'razonCita': null, // ✅ nuevo
    'estado': null,     // ✅ nuevo
    'fechaDesde': null,
    'fechaHasta': null,
    'horaDesde': null,
    'horaHasta': null,
  };

  final List<EventoCalendar> _eventos = [];
  List<EventoCalendar> get eventos => _eventos;

  Future<void> cargarEventosDesdeBackend() async {
    try {
      _eventos.clear();
      final mascotas = MascotasStorage.getMascotas();
      for (final mascota in mascotas) {
        final detalles = await _petService.obtenerDetallesMascota(mascota.id);

        _eventos.addAll(detalles.eventos.map((evento) {
          final ec = EventoCalendar(
            id: evento.id.toString(),
            titulo: evento.titulo,
            hora: _formatoHora(evento.hora),
            fecha: _formatoFecha(evento.fecha),
            mascota: mascota.nombre,
            veterinario: evento.veterinario?.nombreCompleto ?? 'No especificado',
            tipo: 'evento',
            categoria: evento.categoria?.nombre ?? 'Evento general',
            estado: null,
            descripcion: evento.descripcion,
          );
          return ec;
        }));

        _eventos.addAll(detalles.citas.map((cita) {
          final ec = EventoCalendar(
            id: cita.id.toString(),
            titulo: cita.razon,
            hora: _formatoHora(cita.hora),
            fecha: _formatoFecha(cita.fecha),
            mascota: mascota.nombre,
            veterinario: cita.veterinario?.nombreCompleto ?? 'Veterinario asignado',
            tipo: 'cita',
            categoria: null,
            estado: cita.estado,
            descripcion: cita.descripcion,
          );
          return ec;
        }));
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando eventos del calendario: $e');
    }
  }

  String _formatoFecha(DateTime fecha) =>
      '${fecha.year}-${_dos(fecha.month)}-${_dos(fecha.day)}';

  String _formatoHora(DateTime hora) =>
      '${_dos(hora.hour)}:${_dos(hora.minute)}';

  String _dos(int n) => n.toString().padLeft(2, '0');


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

    final eventosDelDia = _eventos.where((e) => e.fecha == formato).toList();

    eventosDelDia.sort((a, b) {
      final horaA = TimeOfDay(
        hour: int.parse(a.hora.split(':')[0]),
        minute: int.parse(a.hora.split(':')[1]),
      );
      final horaB = TimeOfDay(
        hour: int.parse(b.hora.split(':')[0]),
        minute: int.parse(b.hora.split(':')[1]),
      );
      return horaA.hour != horaB.hour
          ? horaA.hour.compareTo(horaB.hour)
          : horaA.minute.compareTo(horaB.minute);
    });

    return eventosDelDia;
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
      final rc = filtrosAvanzados['razonCita'];
      final es = filtrosAvanzados['estado'];
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
      final bool coincideRazon = rc == null || evento.titulo == rc;
      final bool coincideEstado = es == null || evento.estado == es;

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
          coincideRazon &&
          coincideEstado &&
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
}


