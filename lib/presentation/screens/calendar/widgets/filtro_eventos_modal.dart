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
    final Map<String, dynamic> filtros =
        widget.filtrosActuales ?? <String, dynamic>{};
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
    final DateTime? picked = await showDatePicker(
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
    final TimeOfDay? picked = await showTimePicker(
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
      categoriaSeleccionada = null;
      fechaDesde = null;
      fechaHasta = null;
      horaDesde = null;
      horaHasta = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle? textStyle = theme.textTheme.bodyMedium;

    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Filtros avanzados',
        style:
            theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Mascota', style: textStyle),
            DropdownButton<String>(
              value: mascotaSeleccionada,
              hint: Text('Selecciona una mascota', style: textStyle),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              items: widget.mascotas
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: textStyle),
                    ),
                  )
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
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: textStyle),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => veterinarioSeleccionado = value),
            ),
            const SizedBox(height: 10),
            Text('Tipo de evento', style: textStyle),
            DropdownButton<String>(
              value: tipoSeleccionado,
              hint: Text('Cita o Evento', style: textStyle),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              items: <String>['cita', 'evento']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: textStyle),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => tipoSeleccionado = value),
            ),
            const SizedBox(height: 10),
            Text('Categoría', style: textStyle),
            DropdownButton<String>(
              value: categoriaSeleccionada,
              hint: Text('Selecciona una categoría', style: textStyle),
              isExpanded: true,
              dropdownColor: theme.cardColor,
              items: widget.categorias
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: textStyle),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => categoriaSeleccionada = value),
            ),
            const SizedBox(height: 10),
            Text('Rango de fechas', style: textStyle),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarFecha(context, true),
                    child: Text(
                      fechaDesde == null
                          ? 'Desde'
                          : '${fechaDesde!.day}/${fechaDesde!.month}/${fechaDesde!.year}',
                      style: textStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarFecha(context, false),
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
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarHora(context, true),
                    child: Text(
                      horaDesde == null ? 'Desde' : horaDesde!.format(context),
                      style: textStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => seleccionarHora(context, false),
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
      actions: <Widget>[
        TextButton(
          onPressed: limpiarCampos,
          child:
              Text('Limpiar todo', style: TextStyle(color: colorScheme.error)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
              Text('Cancelar', style: TextStyle(color: colorScheme.onSurface)),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final Map<String, dynamic> filtros = <String, dynamic>{
              'mascota': mascotaSeleccionada,
              'veterinario': veterinarioSeleccionado,
              'tipo': tipoSeleccionado,
              'categoria': categoriaSeleccionada,
              'fechaDesde': fechaDesde,
              'fechaHasta': fechaHasta,
              'horaDesde': horaDesde,
              'horaHasta': horaHasta,
            };
            Navigator.pop(context);
            widget.onAplicar(filtros);
          },
          icon: const Icon(Icons.check),
          label: const Text('Aplicar'),
        ),
      ],
    );
  }
}
