import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_controller.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());

    return Scaffold(
      backgroundColor: const Color(0xFFA6DCEF),
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
              isCalendarMode: true, // <<<<<< Aquí activas modo calendario
            ),
            const SizedBox(height: 10),

// ---------------------------------------------------------------------------------------------------------------------

            // Header personalizado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: const Color(0xFF3E0B53),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _selectMonth(context, controller),
                        child: Obx(() => Text(
                          _monthName(controller.focusedDay.value.month),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _selectYear(context, controller),
                        child: Obx(() => Text(
                          '${controller.focusedDay.value.year}',
                          style: const TextStyle(
                            color: Colors.white,
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

// ---------------------------------------------------------------------------------------------------------------------

            // Calendario
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    defaultBuilder: (context, day, focusedDay) {
                      if (controller.isDayLoaded(day)) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.orangeAccent, width: 2),
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }
                      return null;
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      if (controller.isDayLoaded(day)) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3E0B53),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },

                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return null;
                      
                      List<Widget> markers = events.take(4).map((evento) {
                        final nombre = (evento as Map<String, String>)['nombre']?.toLowerCase() ?? '';

                        Color color;
                        if (nombre.contains('baño')) {
                          color = Colors.blue;
                        } else if (nombre.contains('veterinario') || nombre.contains('consulta')) {
                          color = Colors.green;
                        } else if (nombre.contains('medicina') || nombre.contains('medicamento')) {
                          color = Colors.yellow.shade700;
                        } else if (nombre.contains('vacuna')) {
                          color = Colors.lightBlueAccent;
                        } else {
                          color = Colors.purple;
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        );
                      }).toList();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: markers,
                      );
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
                  color: const Color(0xFF3E0B53),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${eventos.length} eventos para ${controller.focusedDay.value.day}/${controller.focusedDay.value.month}/${controller.focusedDay.value.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),

            // Lista de eventos
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  final eventos = controller.obtenerEventosPorDia(controller.focusedDay.value);

                  if (eventos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay recordatorios para este día',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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

                      Color cardColor;
                      IconData icono;

                      if (nombre.toLowerCase().contains('baño')) {
                        icono = Icons.shower;
                        cardColor = Colors.blue;
                      } else if (nombre.toLowerCase().contains('veterinario') || nombre.toLowerCase().contains('consulta')) {
                        icono = Icons.local_hospital;
                        cardColor = Colors.green;
                      } else if (nombre.toLowerCase().contains('medicina') || nombre.toLowerCase().contains('medicamento')) {
                        icono = Icons.medical_services;
                        cardColor = Colors.yellow.shade700;
                      } else if (nombre.toLowerCase().contains('vacuna')) {
                        icono = Icons.vaccines;
                        cardColor = Colors.lightBlueAccent;
                      } else {
                        icono = Icons.pets;
                        cardColor = Colors.purple;
                      }

                      return Card(
                        color: cardColor,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        
                        child: ListTile(

                          onTap: () {
                            Color cardColor;
                            final nombreLower = nombre.toLowerCase();

                            if (nombreLower.contains('baño')) {
                              cardColor = Colors.blue;
                            } else if (nombreLower.contains('veterinario') || nombreLower.contains('consulta')) {
                              cardColor = Colors.green;
                            } else if (nombreLower.contains('medicina') || nombreLower.contains('medicamento')) {
                              cardColor = Colors.yellow.shade700;
                            } else if (nombreLower.contains('vacuna')) {
                              cardColor = Colors.lightBlueAccent;
                            } else {
                              cardColor = Colors.purple;
                            }

                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (_) => Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    
                                    Text(
                                      'Mascota: ${evento['mascota'] ?? 'Michi'}',
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),

                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(hora, style: const TextStyle(color: Colors.white, fontSize: 16)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(lugar, style: const TextStyle(color: Colors.white, fontSize: 16)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.person, color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(veterinario, style: const TextStyle(color: Colors.white, fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  nombre,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                hora,
                                style: const TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              Icon(icono, color: Colors.white),
                            ],
                          ),
                        ),


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

  void _selectMonth(BuildContext context, CalendarController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                controller.cambiarMes(index + 1);
                Navigator.pop(context);
              },
              child: Text(_monthName(index + 1)),
            );
          },
        );
      },
    );
  }

  void _selectYear(BuildContext context, CalendarController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: 11,
          itemBuilder: (context, index) {
            final year = 2020 + index;
            return ListTile(
              title: Text('$year'),
              onTap: () {
                controller.cambiarAnio(year);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

class TableCalendarFormatButton extends StatelessWidget {
  final CalendarController controller;

  const TableCalendarFormatButton({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getFormatName(CalendarFormat format) {
      switch (format) {
        case CalendarFormat.month:
          return 'Mes';
        case CalendarFormat.twoWeeks:
          return '2 Semanas';
        case CalendarFormat.week:
          return '1 Semana';
        default:
          return '';
      }
    }

    return Obx(() => ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3E0B53),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        if (controller.calendarFormat.value == CalendarFormat.month) {
          controller.calendarFormat.value = CalendarFormat.twoWeeks;
        } else if (controller.calendarFormat.value == CalendarFormat.twoWeeks) {
          controller.calendarFormat.value = CalendarFormat.week;
        } else {
          controller.calendarFormat.value = CalendarFormat.month;
        }
      },
      child: Text(getFormatName(controller.calendarFormat.value)),
    ));
  }
}