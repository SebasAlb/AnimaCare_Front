import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_calendario.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_eventos.dart';
import 'package:animacare_front/presentation/screens/calendar/calendar_controller.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/filtro_eventos_modal.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController controller = CalendarController();
  bool _cargandoEventos = true;

  @override
  void initState() {
    super.initState();

    final DateTime hoy = DateTime.now();
    controller.seleccionarDia(hoy, hoy); // Selecciona el día actual desde el inicio

    controller.searchController.addListener(() {
      if (!controller.modoCalendario) {
        setState(() {});
      }
    });

    controller.cargarEventosDesdeBackend().then((_) {
      setState(() {
        _cargandoEventos = false;
      });
    });
  }

  @override
  void dispose() {
    controller.searchController.dispose();
    super.dispose();
  }



  void mostrarDetallesEvento(EventoCalendar evento) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.dialogBackgroundColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      evento.titulo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('🗓 Fecha: ${evento.fecha}'),
                  Text('🕒 Hora: ${evento.hora}'),
                  Text('🐾 Mascota: ${evento.mascota}'),
                  Text('👨‍⚕️ Veterinario: ${evento.veterinario}'),
                  Text('📌 Tipo: ${evento.tipo}'),
                  if (evento.tipo == 'evento')
                    Text('🏷 Categoría: ${evento.categoria ?? 'Evento general'}'),
                  if (evento.estado != null)
                    Text('📋 Estado: ${evento.estado}'),
                  if (evento.descripcion != null && evento.descripcion!.isNotEmpty)
                    Text('📝 Nota: ${evento.descripcion}'),
                  const SizedBox(height: 24),
                  if (evento.esCita) ...<Widget>[
                    TextButton.icon(
                      onPressed: () {
                        SoundService.playButton();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AgendarCitaScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_calendar, color: colorScheme.primary),
                      label: Text(
                        'Reagendar cita',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        SoundService.playButton();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Cita cancelada'),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      label: const Text(
                        'Cancelar cita',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  SoundService.playButton();
                  Navigator.pop(context);
                },
                child: Icon(Icons.close, color: theme.iconTheme.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void abrirFiltroModal(BuildContext context) {
    final List<EventoCalendar> eventos = controller.eventos;

    final List<String> mascotas = eventos
        .map((e) => e.mascota)
        .where((m) => m.trim().isNotEmpty)
        .toSet()
        .toList();

    final List<String> veterinarios = eventos
        .map((e) => e.veterinario)
        .where((v) => v.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final List<String> categorias = eventos
        .where((e) => e.categoria != null && e.categoria!.trim().isNotEmpty)
        .map((e) => e.categoria!)
        .toSet()
        .toList()
      ..sort();

    showDialog(
      context: context,
      builder: (_) => FiltroEventosModal(
        mascotas: mascotas,
        veterinarios: veterinarios,
        categorias: categorias,
        filtrosActuales: controller.filtrosAvanzados,
        onAplicar: (filtros) {
          setState(() {
            controller.aplicarFiltrosAvanzados(filtros);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.homeOwner);
        return false;
      },
      child:Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  const CustomHeader(),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            SoundService.playButton();
                            setState(() => controller.cambiarModo(true));
                            },
                          child: Text(
                            'Calendario',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: controller.modoCalendario
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Text(
                          '  |  ',
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            SoundService.playButton();
                            setState(() => controller.cambiarModo(false));
                            },
                          child: Text(
                            'Eventos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: !controller.modoCalendario
                                  ? colorScheme.primary
                                  : colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.modoCalendario
                        ? VistaCalendario(
                            eventos: controller.eventosDelDia(controller.selectedDay),
                            selectedDay: controller.selectedDay,
                            focusedDay: controller.focusedDay,
                            onDaySelected: (sel, foc) =>
                                setState(() => controller.seleccionarDia(sel, foc)),
                            onTapEvento: mostrarDetallesEvento,
                            eventosMarcados: controller.getDiasConEventos(),
                          )
                        : VistaEventos(
                            eventos: controller.filtrarEventosPorTexto(),
                            controller: controller.searchController,
                            onTapEvento: mostrarDetallesEvento,
                            onSeleccionarFecha: (fecha) {
                              setState(() {
                                controller.seleccionarDia(fecha, fecha);
                                controller.cambiarModo(true);
                              });
                            },
                            onAbrirFiltro: () {
                              SoundService.playButton();
                              abrirFiltroModal(context);
                            },
                          ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: CustomNavBar(
              currentIndex: 2,
              onTap: (int index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, AppRoutes.homeOwner);
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(context, AppRoutes.contactsP);
                    break;
                  case 2:
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(context, AppRoutes.settingsP);
                    break;
                }
              },
            ),
          ),
          if (_cargandoEventos)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
        ]
      ),
    );
  }
}
