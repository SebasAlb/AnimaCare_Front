import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/widgets/calendario_bottom_sheet.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final AgendarCitaController controller = AgendarCitaController();

  InputDecoration _inputDecoration(String label, ThemeData theme) =>
      InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.primary ), // Anterior: theme.colorScheme.onPrimary
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor, // anterior: theme.colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                const CustomHeader(
                  nameScreen: 'Agendar Cita',
                  isSecondaryScreen: true,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Agendar Cita',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: controller.mascotaSeleccionada,
                        decoration: _inputDecoration('Mascota', theme),
                        dropdownColor: theme.colorScheme.onPrimary, // anterior: theme.colorScheme.surface,
                        iconEnabledColor: theme.iconTheme.color,
                        style: TextStyle(color: theme.colorScheme.primary), // anterior: theme.colorScheme.onPrimary
                        items: controller.mascotas
                            .map(
                              (String m) => DropdownMenuItem(
                                value: m,
                                child: Text(
                                  m,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary, // anterior: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) => setState(
                          () => controller.mascotaSeleccionada = value,
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: controller.razonSeleccionada,
                        decoration: _inputDecoration('Razón de la cita', theme),
                        dropdownColor: theme.colorScheme.onPrimary, // anterior: theme.colorScheme.surface,
                        iconEnabledColor: theme.iconTheme.color,
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                        items: controller.razones
                            .map(
                              (String r) => DropdownMenuItem(
                                value: r,
                                child: Text(
                                  r,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary, // anterior: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) => setState(
                          () => controller.razonSeleccionada = value,
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: controller.veterinarioSeleccionado,
                        decoration: _inputDecoration('Veterinario', theme),
                        dropdownColor: theme.colorScheme.onPrimary, // anterior: theme.colorScheme.surface,
                        iconEnabledColor: theme.iconTheme.color,
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                        items: controller.veterinariosDisponibles
                            .map(
                              (String v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  v,
                                  style: TextStyle(
                                    color: theme.colorScheme.primary, // anterior: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            controller.veterinarioSeleccionado = value;
                            controller.fechaSeleccionada = null; // Reinicia la fecha
                            controller.horaSeleccionada = null;  // Opcional: reinicia la hora también
                          });
                        },

                      ),
                      
                      if (controller.sePuedeMostrarFechaYHora) ...[
                        const SizedBox(height: 14),
                        
                        ListTile(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              builder: (_) => CalendarioBottomSheet(
                                fechaSeleccionada: controller.fechaSeleccionada,
                                esNoLaboral: controller.diaNoLaboral,
                                obtenerMotivoExcepcion: controller.obtenerMotivoExcepcion, // ✅ LLAMADA LIMPIA
                                onFechaSeleccionada: (fecha) {
                                  setState(() {
                                    controller.fechaSeleccionada = fecha;
                                  });
                                },
                              ),
                            );
                          },
                          tileColor: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          title: Text(
                            'Fecha',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                          subtitle: Text(
                            controller.fechaSeleccionada != null
                                ? DateFormat('dd/MM/yyyy').format(controller.fechaSeleccionada!)
                                : 'No seleccionada',
                            style: TextStyle(
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          trailing: Icon(Icons.calendar_today, color: theme.iconTheme.color),
                        ),


                        
                        const SizedBox(height: 14),
                        ListTile(
                          onTap: () async {
                            await controller.mostrarSelectorHora(
                              context,
                              () => setState(() {}),
                            );
                          },
                          tileColor: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          title: Text(
                            'Hora',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                          subtitle: Text(
                            controller.horaSeleccionada ?? 'No seleccionada',
                            style: TextStyle(
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                          ),
                          trailing: Icon(Icons.access_time, color: theme.iconTheme.color),
                        ),
                      ],

                      
                      const SizedBox(height: 14),
                      TextField(
                        controller: controller.notasController,
                        maxLines: 3,
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                        decoration: _inputDecoration(
                          'Notas adicionales (opcional)',
                          theme,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (controller.camposObligatoriosLlenos)
                        ElevatedButton.icon(
                          onPressed: () => controller.confirmarCita(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text('Confirmar cita'),
                        ), 
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  

}
