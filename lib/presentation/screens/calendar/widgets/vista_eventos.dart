import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_card.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/fecha_agrupada.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class VistaEventos extends StatefulWidget {
  const VistaEventos({
    super.key,
    required this.eventos,
    required this.controller,
    required this.onTapEvento,
    required this.onSeleccionarFecha,
    required this.onAbrirFiltro,
  });

  final List<EventoCalendar> eventos;
  final TextEditingController controller;
  final Function(EventoCalendar) onTapEvento;
  final Function(DateTime) onSeleccionarFecha;
  final VoidCallback onAbrirFiltro;

  @override
  State<VistaEventos> createState() => _VistaEventosState();
}

class _VistaEventosState extends State<VistaEventos> {
  final ScrollController _scrollController = ScrollController();
  String? tipoSeleccionado;

  List<String> generarFiltros(List<EventoCalendar> eventos) {
    final Set<String> categorias = <String>{};
    bool tieneCitas = false;
    bool tieneEventos = false;

    for (final EventoCalendar evento in eventos) {
      if (evento.tipo == 'cita') tieneCitas = true;
      if (evento.tipo == 'evento') tieneEventos = true;
      if (evento.categoria != null) categorias.add(evento.categoria!);
    }

    final List<String> filtros = <String>['Todos'];
    if (tieneCitas) filtros.add('Cita');
    if (tieneEventos) filtros.add('Evento');
    return filtros;
  }

  List<EventoCalendar> filtrarEventos() {
    final List<EventoCalendar> todos = widget.eventos;
    final String? tipoFiltro = tipoSeleccionado;

    return todos.where((evento) {
      final bool coincideTipo = tipoFiltro == null ||
          tipoFiltro == 'Todos' ||
          (tipoFiltro == 'Cita' && evento.tipo == 'cita') ||
          (tipoFiltro == 'Evento' && evento.tipo == 'evento') ||
          evento.categoria?.toLowerCase() == tipoFiltro.toLowerCase();

      return coincideTipo;
    }).toList();
  }

  Map<String, List<EventoCalendar>> agruparPorFecha(
      List<EventoCalendar> lista,) {
    final Map<String, List<EventoCalendar>> agrupados = <String, List<EventoCalendar>>{};
    for (final EventoCalendar evento in lista) {
      agrupados.putIfAbsent(evento.fecha, () => <EventoCalendar>[]).add(evento);
    }
    final Map<String, List<EventoCalendar>> ordenado = Map.fromEntries(
      agrupados.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return ordenado;
  }

  void seleccionarFiltro(String tipo, int index) {
    setState(() {
      if (tipo == 'Todos') {
        tipoSeleccionado = 'Todos';
      } else if (tipoSeleccionado == tipo) {
        tipoSeleccionado = null;
      } else {
        tipoSeleccionado = tipo;
      }

      const double chipWidth = 90;
      _scrollController.animateTo(
        (index * chipWidth) - 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final List<EventoCalendar> eventosFiltrados = filtrarEventos();
    final Map<String, List<EventoCalendar>> eventosAgrupados =
        agruparPorFecha(eventosFiltrados);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'Buscar eventos...',
                    hintStyle: TextStyle(color: theme.hintColor),
                    prefixIcon:
                        Icon(Icons.search, color: theme.iconTheme.color),
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.filter_alt, color: colorScheme.primary),
                onPressed: widget.onAbrirFiltro,
                tooltip: 'Filtros avanzados',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 42,
          child: Builder(
            builder: (context) {
              final List<String> filtros = generarFiltros(widget.eventos);

              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtros.length,
                itemBuilder: (context, index) {
                  final String tipo = filtros[index];
                  final bool isSelected = tipo == tipoSeleccionado;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tipo),
                      selected: isSelected,
                      onSelected: (_) => seleccionarFiltro(tipo, index),
                      selectedColor: colorScheme.primary,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: eventosFiltrados.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No se encontraron eventos.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: eventosAgrupados.length,
                  itemBuilder: (context, index) {
                    final String fechaStr =
                        eventosAgrupados.keys.elementAt(index);
                    final List<EventoCalendar> eventosDelDia =
                        eventosAgrupados[fechaStr]!;

                    final DateTime fecha = DateTime.parse(fechaStr);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FechaAgrupada(
                          fecha: fechaStr,
                          onTap: () => widget.onSeleccionarFecha(fecha),
                        ),
                        ...eventosDelDia.map(
                          (evento) => GestureDetector(
                            onTap: () => widget.onTapEvento(evento),
                            child: EventoCard(
                              hora: evento.hora,
                              titulo: evento.titulo,
                              mascota: evento.mascota,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
