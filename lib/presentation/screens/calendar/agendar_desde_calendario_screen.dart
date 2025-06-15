
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/services/notification_service.dart';
import 'package:animacare_front/storage/pet_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_controller.dart';

class AgendarDesdeCalendarioScreen extends StatefulWidget {
  final DateTime? fechaPreseleccionada;

  const AgendarDesdeCalendarioScreen({super.key, this.fechaPreseleccionada});


  @override
  State<AgendarDesdeCalendarioScreen> createState() => _AgendarDesdeCalendarioScreenState();
}

class _AgendarDesdeCalendarioScreenState extends State<AgendarDesdeCalendarioScreen> {
  final AgendarCitaController controller = AgendarCitaController();
  final ScrollController _scrollController = ScrollController();
  final RxBool isLoading = false.obs;
  bool _prevCamposLlenos = false;
  bool _cargandoVeterinarios = true;
  List<Veterinario> veterinariosDisponibles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mascotas = await MascotasStorage.getMascotas();
      setState(() {
        controller.mascotas = mascotas;
        _cargandoVeterinarios = false;
      });
      if (widget.fechaPreseleccionada != null) {
        controller.fechaSeleccionada = widget.fechaPreseleccionada!;
        controller.cargarVeterinarios().then((todos) {
          final disponibles = todos.where((vet) {
            controller.veterinarioSeleccionado = vet;
            return !controller.estaDiaBloqueadoPorExcepcion(widget.fechaPreseleccionada!) &&
                  !controller.diaNoLaboral(widget.fechaPreseleccionada!);
          }).toList();

          setState(() {
            veterinariosDisponibles = disponibles;
            controller.veterinarioSeleccionado = null;
            controller.horaSeleccionada = null;
          });
        });
      }

    });

    _prevCamposLlenos = controller.camposObligatoriosLlenos;
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
  final DateTime hoy = DateTime.now();
  final DateTime? fecha = await showDatePicker(
    context: context,
    initialDate: hoy,
    firstDate: hoy,
    lastDate: hoy.add(const Duration(days: 90)),
    builder: (context, child) => Theme(
      data: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4B1B3F),
          onSurface: Color(0xFF4B1B3F),
        ),
      ),
      child: child!,
    ),
  );

  if (fecha != null) {
    setState(() {
      isLoading.value = true; // ✅ Mostrar cargando SOLO después de elegir la fecha
    });

    controller.fechaSeleccionada = fecha;
    final todos = await controller.cargarVeterinarios();
    final disponibles = todos.where((vet) {
      controller.veterinarioSeleccionado = vet;
      return !controller.estaDiaBloqueadoPorExcepcion(fecha) &&
             !controller.diaNoLaboral(fecha);
    }).toList();

    setState(() {
      veterinariosDisponibles = disponibles;
      controller.veterinarioSeleccionado = null;
      controller.horaSeleccionada = null;
      isLoading.value = false; // ✅ Ocultar cargando
    });
  }
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
        const CustomHeader(
          nameScreen: 'Agendar por Fecha',
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
                      color: theme.colorScheme.primary),
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
              _buildFieldLabel('Fecha', theme),
              
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: ListTile(
                  onTap: () => _seleccionarFecha(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
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


              if (controller.fechaSeleccionada != null) ...[
                const SizedBox(height: 14),
                _buildFieldLabel('Veterinario', theme),
                DropdownButtonFormField<Veterinario>(
                  value: controller.veterinarioSeleccionado,
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
                  items: veterinariosDisponibles
                      .map((v) => DropdownMenuItem<Veterinario>(
                            value: v,
                            child: Text(v.nombreCompleto),
                          ))
                      .toList(),
                  onChanged: (Veterinario? value) {
                    setState(() {
                      controller.veterinarioSeleccionado = value;
                      controller.horaSeleccionada = null;
                    });
                  },
                ),
              ],
              if (controller.veterinarioSeleccionado != null) ...[
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
                    leading: Icon(Icons.access_time, color: theme.colorScheme.primary),
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

                  if (excedido) {
                    final limitado = value.text.characters.take(100).toString();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.notasController.text = limitado;
                      controller.notasController.selection =
                          TextSelection.collapsed(offset: limitado.length);
                    });
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40),
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
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 16, 12, 48),
                          ),
                        ),
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
              ),
              if (controller.camposObligatoriosLlenos)
                ElevatedButton.icon(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          isLoading.value = true;
                          await controller.guardarCita(context);
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
                ),
            ],
          ),
        ),
      ],
    );
  }
}
