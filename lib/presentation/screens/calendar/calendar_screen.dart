import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/services/notification_service.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_calendario.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_eventos.dart';
import 'package:animacare_front/presentation/screens/calendar/calendar_controller.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/filtro_eventos_modal.dart';
import 'package:animacare_front/services/appointment_service.dart'; 
import 'package:animacare_front/models/cita.dart';
import 'package:dio/dio.dart';
import 'package:animacare_front/constants/api_config.dart';
import 'package:get/get.dart';


class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController controller = CalendarController();
  bool _cargandoEventos = true;
  bool _bloqueoCancelacion = false;
  

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


  Future<void> cancelarCita(EventoCalendar evento) async {
    setState(() => _bloqueoCancelacion = true);

    try {
      final dio = Dio();
      final String baseUrl = ApiConfig.baseUrl;

      await dio.post(
        '$baseUrl/v1/appointment/update/${evento.id}',
        data: {'estado': 'Cancelada'},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      await controller.cargarEventosDesdeBackend();
      setState(() {}); // 🔁 Refresca vista si es necesario

      NotificationService.eliminarNotificacion(evento.id);
      SoundService.playSuccess(); // ✅ Sonido de éxito
      Get.snackbar(
        'Cita cancelada',
        'La cita fue cancelada correctamente.',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.check_circle, color: Colors.green),
      );
    } catch (e) {
      SoundService.playWarning(); // ❌ Sonido de error

      Get.snackbar(
        'Error',
        'No se pudo cancelar la cita: $e',
        backgroundColor: Colors.white30,
        colorText: Theme.of(context).colorScheme.onBackground,
        icon: const Icon(Icons.warning, color: Colors.redAccent),
      );
    } finally {
      setState(() => _bloqueoCancelacion = false);
    }
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
                  if (evento.descripcion != null && evento.descripcion!.trim().isNotEmpty)
                    Text('📝 Nota: ${evento.descripcion}'),
                  const SizedBox(height: 24),
                  
                  if (evento.esCita && evento.estado != 'Cancelada') ...<Widget>[
                    TextButton.icon(
                      onPressed: () {
                        SoundService.playButton();
                        Navigator.pop(context);
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AgendarCitaScreen(evento: evento),
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
                        Navigator.pop(context); // Cierra el modal de detalles

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              title: const Text('¿Cancelar cita?'),
                              content: const Text('¿Estás seguro de que deseas cancelar esta cita? Esta acción no se puede deshacer.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    SoundService.playButton();
                                    Navigator.pop(ctx); // Cierra el dialogo
                                  },
                                  child: const Text('No'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    SoundService.playButton();
                                    Navigator.pop(ctx); // Cierra el dialogo
                                    cancelarCita(evento); // Llama la función real
                                  },
                                  child: const Text('Sí, cancelar'),
                                ),
                              ],
                            );
                          },
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

  Widget _buildCalendarTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
          ),
        ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCalendarTab(
                          context: context,
                          label: 'Calendario',
                          isSelected: controller.modoCalendario,
                          onTap: () {
                            SoundService.playButton();
                            setState(() => controller.cambiarModo(true));
                          },
                          theme: theme,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '|',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _buildCalendarTab(
                          context: context,
                          label: 'Eventos',
                          isSelected: !controller.modoCalendario,
                          onTap: () {
                            SoundService.playButton();
                            setState(() => controller.cambiarModo(false));
                          },
                          theme: theme,
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
                            eventMasct: false,
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
          if (_cargandoEventos || _bloqueoCancelacion)
            WillPopScope(
              onWillPop: () async => false,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 170,
                      width: 170,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const SizedBox(
                            height: 170,
                            width: 170,
                            child: CircularProgressIndicator(
                              strokeWidth: 6,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          ClipOval(
                            child: Image.asset(
                              'assets/images/animacion_calendario.gif',
                              height: 170,
                              width: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ]
      ),
    );
  }
}




