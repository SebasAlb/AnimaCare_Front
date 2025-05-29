import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/storage/veterinarian_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_controller.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/widgets/calendario_bottom_sheet.dart';

class AgendarCitaScreen extends StatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final AgendarCitaController controller = AgendarCitaController();
  final ScrollController _scrollController = ScrollController();
  bool _prevCamposLlenos = false;
  bool _cargandoVeterinarios = true;

  @override
  void initState() {
    super.initState();
    _prevCamposLlenos = controller.camposObligatoriosLlenos;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final veterinarios = await VeterinariosStorage.getVeterinarios();
      setState(() {
        controller.contactosExternos = veterinarios;
        _cargandoVeterinarios = false;
      });
    });

  }

  Widget _buildFieldLabel(String label, ThemeData theme) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (_cargandoVeterinarios) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final actualLleno = controller.camposObligatoriosLlenos;
      if (!_prevCamposLlenos && actualLleno) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
      _prevCamposLlenos = actualLleno;
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                CustomHeader(
                  nameScreen: 'Agendar Cita',
                  isSecondaryScreen: true,
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
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

                      _buildFieldLabel('Mascota', theme),
                      DropdownButtonFormField<String>( // Seleccionar Mascota
                        value: controller.mascotaSeleccionada,
                        decoration: InputDecoration(
                          hintText: 'Seleccione una mascota',
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(Icons.pets, color: theme.colorScheme.primary), // ✅ Ícono añadido
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        iconEnabledColor: theme.iconTheme.color,
                        style: TextStyle(color: theme.colorScheme.primary),
                        items: controller.mascotas
                            .map((String m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (String? value) => setState(() => controller.mascotaSeleccionada = value),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Razón de la cita', theme),
                      DropdownButtonFormField<String>(
                        value: controller.razonSeleccionada,
                        decoration: InputDecoration(
                          hintText: 'Seleccione una razón',
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(Icons.medical_services, color: theme.colorScheme.primary), // ✅ Ícono añadido
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        iconEnabledColor: theme.iconTheme.color,
                        style: TextStyle(color: theme.colorScheme.primary),
                        items: controller.razones
                            .map((String r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (String? value) => setState(() => controller.razonSeleccionada = value),
                      ),
                      const SizedBox(height: 14),

                      _buildFieldLabel('Veterinario', theme),
                      DropdownButtonFormField<String>(
                        value: controller.veterinarioSeleccionado,
                        decoration: InputDecoration(
                          hintText: 'Seleccione un veterinario',
                          filled: true,
                          fillColor: theme.colorScheme.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: Icon(Icons.person_outline, color: theme.colorScheme.primary),
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        iconEnabledColor: theme.iconTheme.color,
                        style: TextStyle(color: theme.colorScheme.primary),
                        items: controller.veterinariosDisponibles
                            .map((String v) => DropdownMenuItem(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            controller.veterinarioSeleccionado = value;
                            controller.fechaSeleccionada = null;
                            controller.horaSeleccionada = null;
                          });
                        },
                      ),
                      if (controller.sePuedeMostrarFechaYHora) ...[
                        const SizedBox(height: 14),
                        _buildFieldLabel('Fecha', theme),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: ListTile(
                            onTap: () async {
                              await showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (_) => CalendarioBottomSheet(
                                  fechaSeleccionada: controller.fechaSeleccionada,
                                  esNoLaboral: controller.diaNoLaboral,
                                  obtenerMotivoExcepcion: controller.obtenerMotivoExcepcion,
                                  onFechaSeleccionada: (fecha) {
                                    setState(() {
                                      controller.fechaSeleccionada = fecha;
                                      controller.horaSeleccionada = null; // ✅ Reinicia la hora
                                    });
                                  },
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: Icon(Icons.calendar_today, color: theme.colorScheme.primary), // ✅ Ícono alineado
                            title: Text(
                              controller.fechaSeleccionada != null
                                  ? DateFormat('dd/MM/yyyy').format(controller.fechaSeleccionada!)
                                  : 'Seleccione una fecha',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildFieldLabel('Hora', theme),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: ListTile(
                            onTap: () async {
                              await controller.mostrarSelectorHora(
                                context,
                                () => setState(() {}),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            leading: Icon(Icons.access_time, color: theme.colorScheme.primary), // ✅ Ícono a la izquierda
                            title: Text(
                              controller.horaSeleccionada ?? 'Seleccione una hora',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),

                      _buildFieldLabel('Notas adicionales (opcional)', theme),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller.notasController,
                        builder: (context, value, _) {
                          final words = value.text.trim().isEmpty
                              ? <String>[]
                              : value.text.trim().split(RegExp(r'\s+'));

                          final wordCount = words.length;
                          final bool enLimite = wordCount == 20;
                          final bool excedido = wordCount > 20;

                          // ✅ Aplicar el límite solo si lo supera
                          if (excedido) {
                            final limitado = words.sublist(0, 20).join(' ');
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.notasController.text = limitado;
                              controller.notasController.selection =
                                  TextSelection.collapsed(offset: limitado.length);
                            });
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 40), // deja espacio final para que no tape el teclado
                            child: Stack(
                              children: [
                                TextField(
                                  controller: controller.notasController,
                                  maxLines: 3,
                                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
                                  decoration: InputDecoration(
                                    hintText: 'Ingrese detalles adicionales si es necesario',
                                    hintStyle: TextStyle(color: theme.hintColor),
                                    filled: true,
                                    fillColor: theme.colorScheme.surface,
                                    prefixIcon: Icon(Icons.notes, color: theme.colorScheme.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(12, 16, 12, 48), // más espacio abajo
                                  ),
                                ),
                                // ✅ Contador fijo
                                Positioned(
                                  bottom: 8,
                                  right: 12,
                                  child: Text(
                                    '$wordCount / 20 palabras',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: enLimite ? Colors.redAccent : theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                // ✅ Mensaje de advertencia solo si está exactamente en 20 palabras
                                if (enLimite)
                                  Positioned(
                                    bottom: -18,
                                    left: 4,
                                    child: Text(
                                      'Límite de 20 palabras alcanzado.',
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),



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
