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
            Obx(() {
              if (controller.modoEventos.value) {
                return const SizedBox(); // Ocultamos el header cuando está en modo eventos
              }

              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                color: AppColors.header,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _openMonthPicker(context, controller),
                          child: Text(
                            _monthName(controller.focusedDay.value.month),
                            style: const TextStyle(
                              color: AppColors.primaryWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _openYearPicker(context, controller),
                          child: Text(
                            '${controller.focusedDay.value.year}',
                            style: const TextStyle(
                              color: AppColors.primaryWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableCalendarFormatButton(controller: controller),
                  ],
                ),
              );
            }),

            // Calendario
            Obx(() {
              if (controller.modoEventos.value) {
                return const SizedBox(); // Ocultamos el calendario en modo eventos
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TableCalendar(
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
                    selectedDayPredicate: (day) =>
                        isSameDay(controller.focusedDay.value, day),
                    eventLoader: (day) => controller.obtenerEventosPorDia(day),
                    headerVisible: false,
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) =>
                          CalendarDayItem(
                        day: day,
                        isSelected: false,
                        isOverloaded: controller.isDayLoaded(day),
                      ),
                      selectedBuilder: (context, day, focusedDay) =>
                          CalendarDayItem(
                        day: day,
                        isSelected: true,
                        isOverloaded: controller.isDayLoaded(day),
                      ),
                      markerBuilder: (context, date, events) {
                        final eventList = events.cast<Map<String, String>>();
                        return EventMarkers(eventos: eventList);
                      },
                    ),
                  ),
                ),
              );
            }),

            // Label del día seleccionado
            Obx(() {
              final eventosEnFecha = controller
                  .obtenerEventosPorDia(controller.focusedDay.value)
                  .length;

              return GestureDetector(
                onTap: controller.toggleModoEventos,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.labelBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.modoEventos.value
                            ? 'Eventos'
                            : '$eventosEnFecha ${eventosEnFecha == 1 ? 'evento' : 'eventos'} en ${controller.focusedDay.value.day}/${controller.focusedDay.value.month}/${controller.focusedDay.value.year}', // Condicional para singular/plural
                        style: const TextStyle(
                          color: AppColors.primaryWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        controller.modoEventos.value
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            }),

            Obx(() {
              if (!controller.modoEventos.value) {
                return const SizedBox(); // 🔥 Si no estamos en modo eventos, NO mostrar el buscador
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar eventos...',
                    filled: true,
                    fillColor: AppColors.primaryWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    controller.searchQuery.value =
                        value; // 🔥 Actualiza el valor del filtro
                  },
                ),
              );
            }),

            // Lista de eventos del día
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  if (controller.modoEventos.value) {
                    final eventosFiltrados = controller.eventosFiltrados;

                    if (eventosFiltrados.isEmpty) {
                      return const Center(
                        child: Text('No hay eventos que coincidan.',
                            style: TextStyle(color: AppColors.primaryWhite)),
                      );
                    }

                    DateTime?
                        ultimaFechaMostrada; // 🔥 Declarar fuera del ListView para controlarlo en todo el recorrido

                    return ListView.builder(
                      itemCount: eventosFiltrados.length,
                      itemBuilder: (context, index) {
                        final item = eventosFiltrados[index];
                        final evento = item['evento'] as Map<String, String>;
                        final fecha = item['fecha'] as DateTime;

                        // 🔥 Verificar si hay que mostrar la fecha o no
                        bool mostrarFecha = false;
                        if (ultimaFechaMostrada == null ||
                            !isSameDay(ultimaFechaMostrada, fecha)) {
                          mostrarFecha = true;
                          ultimaFechaMostrada = fecha;
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (mostrarFecha)
                              GestureDetector(
                                onTap: () {
                                  controller.focusedDay.value = fecha;
                                  controller
                                      .toggleModoEventos(); // 🔥 Volver a modo calendario
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.labelBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${fecha.day}/${fecha.month}/${fecha.year}',
                                    style: const TextStyle(
                                      color: AppColors.primaryWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            EventCard(
                              nombre: evento['nombre'] ?? '',
                              hora: evento['hora'] ?? '',
                              lugar: evento['lugar'] ?? '',
                              veterinario: evento['veterinario'] ?? '',
                              mascota: evento['mascota'] ?? '',
                              color: controller
                                  .obtenerColorEvento(evento['nombre'] ?? ''),
                              icono: controller
                                  .obtenerIconoEvento(evento['nombre'] ?? ''),
                              onTap: () {
                                _showEventDetails(
                                  context,
                                  evento['nombre'] ?? '',
                                  evento['hora'] ?? '',
                                  evento['lugar'] ?? '',
                                  evento['veterinario'] ?? '',
                                  evento['mascota'] ?? '',
                                  evento['anticipacion'] ?? '',
                                  evento['frecuencia'] ?? '',
                                  evento['recibirRecordatorio'] ?? '',
                                  0, // No importa el índice en modo búsqueda
                                  controller,
                                  fechaReal: fecha,
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  } else {
                    // 🔥 Código original de eventos por día (cuando modoEventos = false)
                    final eventos = controller
                        .obtenerEventosPorDia(controller.focusedDay.value);

                    if (eventos.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay recordatorios para este día',
                          style: TextStyle(
                              color: AppColors.primaryWhite, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        final evento = eventos[index];
                        return EventCard(
                          nombre: evento['nombre'] ?? '',
                          hora: evento['hora'] ?? '',
                          lugar: evento['lugar'] ?? '',
                          veterinario: evento['veterinario'] ?? '',
                          mascota: evento['mascota'] ?? '',
                          color: controller
                              .obtenerColorEvento(evento['nombre'] ?? ''),
                          icono: controller
                              .obtenerIconoEvento(evento['nombre'] ?? ''),
                          onTap: () {
                            _showEventDetails(
                              context,
                              evento['nombre'] ?? '',
                              evento['hora'] ?? '',
                              evento['lugar'] ?? '',
                              evento['veterinario'] ?? '',
                              evento['mascota'] ?? '',
                              evento['anticipacion'] ?? '',
                              evento['frecuencia'] ?? '',
                              evento['recibirRecordatorio'] ?? '',
                              index,
                              controller,
                            );
                          },
                        );
                      },
                    );
                  }
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
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.ownerUpdate);
              break;
          }
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
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

  void _showEventDetails(
      BuildContext context,
      String nombre,
      String hora,
      String lugar,
      String veterinario,
      String mascota,
      String anticipacion,
      String frecuencia,
      String recibirRecordatorio,
      int index,
      CalendarController controller,
      {DateTime? fechaReal}) {
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final confirmar = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('¿Eliminar evento?'),
                        content: const Text(
                            '¿Seguro que deseas eliminar este evento?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirmar == true) {
                      if (fechaReal != null) {
                        // Si pasaron fecha real (modo eventos)
                        final eventosDelDia =
                            controller.obtenerEventosPorDia(fechaReal);
                        final eventoIndex = eventosDelDia.indexWhere((evento) =>
                            evento['nombre'] == nombre &&
                            evento['hora'] == hora);
                        if (eventoIndex != -1) {
                          controller.eliminarEvento(fechaReal, eventoIndex);
                        }
                      } else {
                        // Vista calendario normal
                        controller.eliminarEvento(
                            controller.focusedDay.value, index);
                      }

                      controller.focusedDay.refresh();
                      Navigator.pop(context);
                      Get.snackbar(
                        'Evento eliminado',
                        'Se eliminó correctamente.',
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.access_time, hora),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.location_on, lugar),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.person, veterinario),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.pets, mascota),
            const SizedBox(height: 10),
            _buildDetailRow(Icons.notifications_active, recibirRecordatorio),
            if (recibirRecordatorio != 'No recibir') ...[
              const SizedBox(height: 10),
              _buildDetailRow(Icons.alarm, anticipacion),
              const SizedBox(height: 10),
              _buildDetailRow(Icons.repeat, frecuencia),
            ]
          ],
        ),
      ),
    );
  }

  Color _determineEventColor(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('baño')) return AppColors.eventBath;
    if (lower.contains('veterinario') || lower.contains('consulta'))
      return AppColors.eventVetConsult;
    if (lower.contains('medicina') || lower.contains('medicamento'))
      return AppColors.eventMedicine;
    if (lower.contains('vacuna')) return AppColors.eventVaccine;
    return AppColors.eventOther;
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryWhite),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style:
                  const TextStyle(color: AppColors.primaryWhite, fontSize: 16)),
        ),
      ],
    );
  }
}
