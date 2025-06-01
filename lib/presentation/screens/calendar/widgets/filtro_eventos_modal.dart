import 'package:flutter/material.dart';

class FiltroEventosModal extends StatefulWidget {
  const FiltroEventosModal({
    super.key,
    required this.mascotas,
    required this.veterinarios,
    required this.categorias,
    required this.onAplicar,
    this.filtrosActuales,
  });

  final List<String> mascotas;
  final List<String> veterinarios;
  final List<String> categorias;
  final Function(Map<String, dynamic>) onAplicar;
  final Map<String, dynamic>? filtrosActuales;

  @override
  State<FiltroEventosModal> createState() => _FiltroEventosModalState();
}

class _FiltroEventosModalState extends State<FiltroEventosModal> {
  String? categoriaEventoSeleccionada;
  String? razonCitaSeleccionada;
  String? estadoSeleccionado;
  String? mascotaSeleccionada;
  String? veterinarioSeleccionado;
  String? tipoSeleccionado;
  String? categoriaSeleccionada;
  DateTime? fechaDesde;
  DateTime? fechaHasta;
  TimeOfDay? horaDesde;
  TimeOfDay? horaHasta;
  
  @override
  void initState() {
    super.initState();
    final filtros = widget.filtrosActuales ?? <String, dynamic>{};
    categoriaEventoSeleccionada = filtros['categoria'];
    razonCitaSeleccionada = filtros['razonCita'];
    estadoSeleccionado = filtros['estado'];
    mascotaSeleccionada = filtros['mascota'];
    veterinarioSeleccionado = filtros['veterinario'];
    tipoSeleccionado = filtros['tipo'];
    categoriaSeleccionada = filtros['categoria'];
    fechaDesde = filtros['fechaDesde'];
    fechaHasta = filtros['fechaHasta'];
    horaDesde = filtros['horaDesde'];
    horaHasta = filtros['horaHasta'];
  }

  Future<void> seleccionarFecha(BuildContext context, bool esInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        esInicio ? fechaDesde = picked : fechaHasta = picked;
      });
    }
  }

  Future<void> seleccionarHora(BuildContext context, bool esInicio) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        esInicio ? horaDesde = picked : horaHasta = picked;
      });
    }
  }

  void limpiarCampos() {
    setState(() {
      mascotaSeleccionada = null;
      veterinarioSeleccionado = null;
      tipoSeleccionado = null;
      categoriaEventoSeleccionada = null;
      razonCitaSeleccionada = null;
      estadoSeleccionado = null;
      fechaDesde = null;
      fechaHasta = null;
      horaDesde = null;
      horaHasta = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.bodyMedium;

    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Filtros avanzados',
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mascota', style: textStyle),
            DropdownButton<String>(
              value: mascotaSeleccionada,
              hint: Text('Selecciona una mascota', style: textStyle),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              items: widget.mascotas
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: textStyle)))
                  .toList(),
              onChanged: (value) => setState(() => mascotaSeleccionada = value),
            ),
            const SizedBox(height: 10),
            Text('Veterinario', style: textStyle),
            DropdownButton<String>(
              value: veterinarioSeleccionado,
              hint: Text('Selecciona un veterinario', style: textStyle),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              items: widget.veterinarios
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: textStyle)))
                  .toList(),
              onChanged: (value) => setState(() => veterinarioSeleccionado = value),
            ),
            const SizedBox(height: 10),
            Text('Tipo de evento', style: textStyle),
            DropdownButton<String>(
              value: tipoSeleccionado,
              hint: Text('Cita o Evento', style: textStyle),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              items: ['Cita', 'Evento']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e, style: textStyle)))
                  .toList(),
              onChanged: (value) => setState(() {
                tipoSeleccionado = value;
              }),
            ),
            const SizedBox(height: 10),
            if (tipoSeleccionado == 'Evento') ...[
              Text('Categoría', style: textStyle),
              DropdownButton<String>(
                value: categoriaEventoSeleccionada,
                hint: Text('Selecciona una categoría', style: textStyle),
                isExpanded: true,
                dropdownColor: theme.cardColor,
                //items: widget.categorias
                items: ['Vacuna', 'Desparacitación', 'Control general', 'Cirugía', 'Recomendación', 'Medicación', 'Cumpleaños']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: textStyle)))
                    .toList(),
                onChanged: (value) => setState(() => categoriaEventoSeleccionada = value),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 10),
            if (tipoSeleccionado == 'Cita') ...[
              Text('Razón', style: textStyle),
              DropdownButton<String>(
                value: razonCitaSeleccionada,
                hint: Text('Selecciona la razón de cita', style: textStyle),
                isExpanded: true,
                dropdownColor: theme.cardColor,
                //items: widget.categorias
                items: ['Consulta general', 'Vacunación', 'Desparasitación', 'Control postoperatorio', 'Emergencia', 'Chequeo geriátrico']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: textStyle)))
                    .toList(),
                onChanged: (value) => setState(() => razonCitaSeleccionada = value),
              ),
              const SizedBox(height: 10),
              Text('Estado', style: textStyle),
              DropdownButton<String>(
                value: estadoSeleccionado,
                hint: Text('Selecciona el estado', style: textStyle),
                isExpanded: true,
                dropdownColor: theme.cardColor,
                items: ['Pendiente', 'Confirmada', 'Cancelada']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e, style: textStyle)))
                    .toList(),
                onChanged: (value) => setState(() => estadoSeleccionado = value),
              ),
            ],
            Text('Rango de fechas', style: textStyle),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarFecha(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.lightBlue.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      fechaDesde == null
                          ? 'Desde'
                          : '${fechaDesde!.day}/${fechaDesde!.month}/${fechaDesde!.year}',
                      style: textStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarFecha(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: const Color(0xFFFFA726).withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      fechaHasta == null
                          ? 'Hasta'
                          : '${fechaHasta!.day}/${fechaHasta!.month}/${fechaHasta!.year}',
                      style: textStyle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Rango de horas', style: textStyle),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarHora(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.lightBlue.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      horaDesde == null ? 'Desde' : horaDesde!.format(context),
                      style: textStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarHora(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: const Color(0xFFFFA726).withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      horaHasta == null ? 'Hasta' : horaHasta!.format(context),
                      style: textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: limpiarCampos,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Limpiar', style: TextStyle(color: colorScheme.error)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final filtros = {
                        'mascota': mascotaSeleccionada,
                        'veterinario': veterinarioSeleccionado,
                        'tipo': tipoSeleccionado,
                        'categoria': tipoSeleccionado == 'Evento' ? categoriaEventoSeleccionada : null,
                        'razonCita': tipoSeleccionado == 'Cita' ? razonCitaSeleccionada : null,
                        'estado': tipoSeleccionado == 'Cita' ? estadoSeleccionado : null,
                        'fechaDesde': fechaDesde,
                        'fechaHasta': fechaHasta,
                        'horaDesde': horaDesde,
                        'horaHasta': horaHasta,
                      };
                      Navigator.pop(context);
                      widget.onAplicar(filtros);
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text('Aplicar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red.withOpacity(0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.close, color: Colors.white),
              label: const Text('Cancelar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}
