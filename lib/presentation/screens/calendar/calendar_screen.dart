import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_controller.dart';
import 'widgets/event_card.dart';
import 'widgets/calendar_day_item.dart';
import 'widgets/event_markers.dart';
import 'widgets/month_year_picker.dart';
import 'widgets/table_calendar_format_button.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // << Importación correcta

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              petName: 'Mi Calendario',
              onEdit: () {
                Navigator.pushNamed(context, AppRoutes.addEvent);
              },
              onViewRecord: () {
                Navigator.pushNamed(context, AppRoutes.editNotifications);
              },
              isCalendarMode: true,
            ),
            const SizedBox(height: 10),

            // Header personalizado (Mes y Año)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: AppColors.header,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _openMonthPicker(context, controller),
                        child: Obx(() => Text(
                              _monthName(controller.focusedDay.value.month),
                              style: const TextStyle(
                                color: AppColors.primaryWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _openYearPicker(context, controller),
                        child: Obx(() => Text(
                              '${controller.focusedDay.value.year}',
                              style: const TextStyle(
                                color: AppColors.primaryWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ],
                  ),
                  TableCalendarFormatButton(controller: controller),
                ],
              ),
            ),

            // Calendario
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Obx(() => TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: controller.focusedDay.value,
                      calendarFormat: controller.calendarFormat.value,
                      onFormatChanged: (format) {
                        controller.calendarFormat.value = format;
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        controller.focusedDay.value = selectedDay;
                      },
                      onPageChanged: (focusedDay) {
                        controller.focusedDay.value = focusedDay;
                      },
                      selectedDayPredicate: (day) => isSameDay(controller.focusedDay.value, day),
                      eventLoader: (day) => controller.obtenerEventosPorDia(day),
                      headerVisible: false,
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) => CalendarDayItem(
                          day: day,
                          isSelected: false,
                          isOverloaded: controller.isDayLoaded(day),
                        ),
                        selectedBuilder: (context, day, focusedDay) => CalendarDayItem(
                          day: day,
                          isSelected: true,
                          isOverloaded: controller.isDayLoaded(day),
                        ),
                        markerBuilder: (context, date, events) {
                          final eventList = events.cast<Map<String, String>>();
                          return EventMarkers(eventos: eventList);
                        },
                      ),
                    )),
              ),
            ),

            // Label del día seleccionado
            Obx(() {
              final eventos = controller.obtenerEventosPorDia(controller.focusedDay.value);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.labelBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${eventos.length} eventos para ${controller.focusedDay.value.day}/${controller.focusedDay.value.month}/${controller.focusedDay.value.year}',
                  style: const TextStyle(
                    color: AppColors.primaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),

            // Lista de eventos del día
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  final eventos = controller.obtenerEventosPorDia(controller.focusedDay.value);

                  if (eventos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay recordatorios para este día',
                        style: TextStyle(color: AppColors.primaryWhite, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      final evento = eventos[index];
                      final nombre = evento['nombre'] ?? '';
                      final hora = evento['hora'] ?? '';
                      final lugar = evento['lugar'] ?? '';
                      final veterinario = evento['veterinario'] ?? '';
                      final mascota = evento['mascota'] ?? '';

                      return EventCard(
                        nombre: nombre,
                        hora: hora,
                        lugar: lugar,
                        veterinario: veterinario,
                        mascota: mascota,
                        color: controller.obtenerColorEvento(nombre),
                        icono: controller.obtenerIconoEvento(nombre),
                        onTap: () {
                          _showEventDetails(context, nombre, hora, lugar, veterinario, mascota);
                        },
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.recommendations);
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month];
  }

  void _openMonthPicker(BuildContext context, CalendarController controller) {
    showModalBottomSheet(
      context: context,
      builder: (_) => MonthPickerSheet(controller: controller),
    );
  }

  void _openYearPicker(BuildContext context, CalendarController controller) {
    showModalBottomSheet(
      context: context,
      builder: (_) => YearPickerSheet(controller: controller),
    );
  }

  void _showEventDetails(BuildContext context, String nombre, String hora, String lugar, String veterinario, String mascota) {
    final color = _determineEventColor(nombre);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primaryWhite),
            ),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time, hora),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.location_on, lugar),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.person, veterinario),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.pets, mascota),
          ],
        ),
      ),
    );
  }

  Color _determineEventColor(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('baño')) return AppColors.eventBath;
    if (lower.contains('veterinario') || lower.contains('consulta')) return AppColors.eventVetConsult;
    if (lower.contains('medicina') || lower.contains('medicamento')) return AppColors.eventMedicine;
    if (lower.contains('vacuna')) return AppColors.eventVaccine;
    return AppColors.eventOther;
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryWhite),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(color: AppColors.primaryWhite, fontSize: 16)),
        ),
      ],
    );
  }
}
