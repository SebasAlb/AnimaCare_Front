import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_calendario.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_eventos.dart';
import 'package:animacare_front/presentation/screens/calendar/calendar_controller.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarController controller = CalendarController();

  void mostrarDetallesEvento(EventoCalendar evento) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFFD5F3F1),
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14746F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("🗓 Fecha: ${evento.fecha}"),
                  Text("🕒 Hora: ${evento.hora}"),
                  Text("🐾 Mascota: ${evento.mascota}"),
                  Text("👨‍⚕️ Veterinario: ${evento.veterinario}"),
                  Text("📌 Tipo: ${evento.tipo}"),
                  if (evento.estado != null) Text("📋 Estado: ${evento.estado}"),
                  if (evento.descripcion != null) Text("📝 Nota: ${evento.descripcion}"),
                  const SizedBox(height: 24),
                  if (evento.esCita) ...<Widget>[
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AgendarCitaScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit_calendar,
                          color: Color(0xFF14746F)),
                      label: const Text('Reagendar cita',
                          style: TextStyle(color: Color(0xFF14746F))),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cita cancelada'),
                            backgroundColor: Color(0xFF4B1B3F),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      label: const Text('Cancelar cita',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomHeader(petName: 'Gato 1'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => controller.cambiarModo(true)),
                    child: Text(
                      'Calendario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: controller.modoCalendario
                            ? colorScheme.primary
                            : colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Text(
                    '  |  ',
                    style: TextStyle(
                        color: colorScheme.onBackground.withOpacity(0.6)),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => controller.cambiarModo(false)),
                    child: Text(
                      'Eventos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: !controller.modoCalendario
                            ? colorScheme.primary
                            : colorScheme.onBackground.withOpacity(0.5),
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
                onDaySelected: (DateTime sel, DateTime foc) =>
                    setState(() => controller.seleccionarDia(sel, foc)),
                onTapEvento: mostrarDetallesEvento,
                eventosMarcados: controller.getDiasConEventos(),
              )
                  : VistaEventos(
                eventos: controller.filtrarEventosPorTexto(),
                controller: controller.searchController,
                onTapEvento: mostrarDetallesEvento,
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
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.contactsP);
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.settingsP);
              break;
          }
        },
      ),
    );
  }
}

