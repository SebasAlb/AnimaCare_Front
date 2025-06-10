import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/services/notification_service.dart';
import 'package:animacare_front/storage/pet_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_controller.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/widgets/calendario_bottom_sheet.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';

class AgendarCitaScreen extends StatefulWidget {
  final EventoCalendar? evento;
  final Veterinario? veterinarioPreseleccionado;

  const AgendarCitaScreen({
    super.key,
    this.evento,
    this.veterinarioPreseleccionado,
  });

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  final AgendarCitaController controller = AgendarCitaController();
  final ScrollController _scrollController = ScrollController();
  final RxBool isLoading = false.obs;
  bool _prevCamposLlenos = false;
  bool _cargandoVeterinarios = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final veterinarios = await controller.cargarVeterinarios();
      final mascotas = await MascotasStorage.getMascotas();

      setState(() {
        controller.contactosExternos = veterinarios;
        controller.mascotas = mascotas;
        _cargandoVeterinarios = false;

        // Si viene un veterinario preseleccionado, lo asignamos al controller
        if (widget.veterinarioPreseleccionado != null) {
          // Buscar el veterinario en la lista de contactos
          final vet = veterinarios.firstWhereOrNull(
              (v) => v.id == widget.veterinarioPreseleccionado!.id);
          if (vet != null) {
            controller.veterinarioSeleccionado = vet;
          }
        }

        if (widget.evento != null) {
          final evento = widget.evento!;

          // Precarga de mascota
          controller.mascotaSeleccionada = mascotas.firstWhere(
            (m) => m.nombre == evento.mascota,
            orElse: () => mascotas.first,
          );

          // Precarga de razón
          if (controller.razones.contains(evento.titulo)) {
            controller.razonSeleccionada = evento.titulo;
          }

          // Precarga de veterinario
          controller.veterinarioSeleccionado = veterinarios.firstWhereOrNull(
            (v) => v.nombreCompleto == evento.veterinario,
          );

          // Precarga de fecha y hora
          try {
            controller.fechaSeleccionada =
                DateFormat('yyyy-MM-dd').parse(evento.fecha);
            controller.horaSeleccionada = evento.hora;
          } catch (_) {
            debugPrint('Error al parsear fecha/hora del evento.');
          }

          // Precarga de descripción
          controller.notasController.text =
              (evento.descripcion ?? '').trim() == ''
                  ? ''
                  : evento.descripcion!;
        }

        if (controller.mascotaSeleccionada != null) {
          final match = mascotas.firstWhere(
            (m) => m.id == controller.mascotaSeleccionada!.id,
            orElse: () => mascotas.first,
          );
          controller.mascotaSeleccionada = match;
        }
      });
    });

    _prevCamposLlenos = controller.camposObligatoriosLlenos;
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

    return Obx(() => WillPopScope(
          onWillPop: () async => !isLoading.value,
          child: Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                body: SafeArea(
                  child: _cargandoVeterinarios
                      ? const Center(child: CircularProgressIndicator())
                      : _buildForm(context, theme),
                ),
              ),
              if (isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ));
  }

  Widget _buildForm(BuildContext context, ThemeData theme) {
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

    return Column(
      children: <Widget>[
        CustomHeader(
          nameScreen: widget.evento != null ? 'Reagendar Cita' : 'Agendar Cita',
          isSecondaryScreen: true,
        ),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              const SizedBox(height: 24),
              _buildFieldLabel('Mascota', theme),
              DropdownButtonFormField<Mascota>(
                value: controller.mascotaSeleccionada,
                decoration: InputDecoration(
                  hintText: 'Seleccione una mascota',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon:
                      Icon(Icons.pets, color: theme.colorScheme.primary),
                ),
                dropdownColor: theme.colorScheme.surface,
                iconEnabledColor: theme.iconTheme.color,
                style: TextStyle(color: theme.colorScheme.primary),
                items: controller.mascotas
                    .map((m) => DropdownMenuItem<Mascota>(
                          value: m,
                          child: Text(m.nombre),
                        ))
                    .toList(),
                onChanged: (Mascota? value) {
                  setState(() {
                    controller.mascotaSeleccionada = value;
                  });
                },
              ),
              const SizedBox(height: 14),

              _buildFieldLabel('Razón de la cita', theme),
              DropdownButtonFormField<String>(
                value: controller.razonSeleccionada,
                decoration: InputDecoration(
                  hintText: 'Seleccione una razón',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.medical_services,
                      color: theme.colorScheme.primary), // ✅ Ícono añadido
                ),
                dropdownColor: theme.colorScheme.surface,
                iconEnabledColor: theme.iconTheme.color,
                style: TextStyle(color: theme.colorScheme.primary),
                items: controller.razones
                    .map((String r) =>
                        DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (String? value) =>
                    setState(() => controller.razonSeleccionada = value),
              ),
              const SizedBox(height: 14),
              _buildFieldLabel('Veterinario', theme),
              DropdownButtonFormField<Veterinario>(
                value: controller
                    .veterinarioSeleccionado, // Quitar la condición con ??
                decoration: InputDecoration(
                  hintText: 'Seleccione un veterinario',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.person_outline,
                      color: theme.colorScheme.primary),
                ),
                dropdownColor: theme.colorScheme.surface,
                iconEnabledColor: theme.iconTheme.color,
                style: TextStyle(color: theme.colorScheme.primary),
                items: controller.contactosExternos
                    .map((v) => DropdownMenuItem<Veterinario>(
                          value: v,
                          child: Text(v.nombreCompleto),
                        ))
                    .toList(),
                onChanged: (Veterinario? value) {
                  setState(() {
                    controller.veterinarioSeleccionado = value;
                    controller.fechaSeleccionada = null;
                    controller.horaSeleccionada = null;
                  });
                },
              ),
              if (controller.veterinarioSeleccionado != null) ...[
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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => CalendarioBottomSheet(
                          fechaSeleccionada: controller.fechaSeleccionada,
                          esNoLaboral: controller.diaNoLaboral,
                          obtenerMotivoExcepcion:
                              controller.obtenerMotivoExcepcion,
                          onFechaSeleccionada: (fecha) {
                            setState(() {
                              controller.fechaSeleccionada = fecha;
                              controller.horaSeleccionada =
                                  null; // ✅ Reinicia la hora
                            });
                          },
                        ),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(Icons.calendar_today,
                        color: theme.colorScheme.primary), // ✅ Ícono alineado
                    title: Text(
                      controller.fechaSeleccionada != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(controller.fechaSeleccionada!)
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(Icons.access_time,
                        color: theme
                            .colorScheme.primary), // ✅ Ícono a la izquierda
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
                  final charCount = value.text.characters.length;
                  final bool enLimite = charCount == 100;
                  final bool excedido = charCount > 100;

                  // ✅ Aplicar el límite solo si lo supera
                  if (excedido) {
                    final limitado = value.text.characters.take(100).toString();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.notasController.text = limitado;
                      controller.notasController.selection =
                          TextSelection.collapsed(offset: limitado.length);
                    });
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom:
                            40), // deja espacio final para que no tape el teclado
                    child: Stack(
                      children: [
                        TextField(
                          controller: controller.notasController,
                          maxLines: 3,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.colorScheme.primary),
                          decoration: InputDecoration(
                            hintText:
                                'Ingrese detalles adicionales si es necesario',
                            hintStyle: TextStyle(color: theme.hintColor),
                            filled: true,
                            fillColor: theme.colorScheme.surface,
                            prefixIcon: Icon(Icons.notes,
                                color: theme.colorScheme.primary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(
                                12, 16, 12, 48), // más espacio abajo
                          ),
                        ),
                        // ✅ Contador fijo
                        Positioned(
                          bottom: 8,
                          right: 12,
                          child: Text(
                            '$charCount / 100 caracteres',
                            style: TextStyle(
                              fontSize: 12,
                              color: enLimite
                                  ? Colors.redAccent
                                  : theme.colorScheme.primary,
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
                              'Límite de 100 caracteres alcanzado.',
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
              ), // Al final, el botón:
              if (controller.camposObligatoriosLlenos)
                Obx(() => ElevatedButton.icon(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              isLoading.value = true;
                              if (widget.evento != null) {
                                await controller.actualizarCitaExistente(
                                    context, widget.evento!.id);
                                await NotificationService.eliminarNotificacion(
                                    widget.evento!.id);
                              } else {
                                await controller.guardarCita(context);
                              }

                              isLoading.value = false;
                            },
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
                    )),
            ],
          ),
        ),
      ],
    );
  }
}
