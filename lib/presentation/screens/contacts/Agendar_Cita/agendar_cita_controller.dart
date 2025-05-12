import 'package:flutter/material.dart';

class AgendarCitaController {
  final List<String> mascotas = <String>['Firulais', 'Pelusa', 'Max'];
  final List<String> razones = <String>[
    'Consulta general',
    'Vacunación',
    'Desparasitación',
    'Control postoperatorio',
    'Emergencia',
    'Chequeo geriátrico',
  ];
  final List<String> veterinarios = <String>[
    'Dra. Lazo',
    'Dr. Mario Paz',
    'Dra. Lucía Andrade',
    'Dr. Esteban Ortega',
  ];
  final List<String> diasSemana = <String>[
    'Lun',
    'Mar',
    'Mié',
    'Jue',
    'Vie',
    'Sáb',
    'Dom',
  ];

  final Map<String, List<String>> horasOcupadas = <String, List<String>>{
    'Lun': <String>['09:00', '10:30'],
    'Mar': <String>['11:00', '14:00'],
    'Mié': <String>['13:00'],
    'Jue': <String>['15:30'],
    'Vie': <String>['09:00', '16:00'],
    'Sáb': <String>[],
    'Dom': <String>[],
  };

  final List<String> horasTotales = List.generate(9, (i) => '${9 + i}:00');

  String? mascotaSeleccionada;
  String? razonSeleccionada;
  String? veterinarioSeleccionado;
  DateTime? fechaSeleccionada;
  String? horaSeleccionada;
  final TextEditingController notasController = TextEditingController();

  Future<void> seleccionarFecha(BuildContext context) async {
    final DateTime hoy = DateTime.now();
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 90)),
      selectableDayPredicate: (day) {
        final List<int> inhabilitados = <int>[15, 22];
        return !inhabilitados.contains(day.day);
      },
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
      fechaSeleccionada = fecha;
    }
  }

  Future<void> mostrarSelectorHora(
      BuildContext context, VoidCallback refreshUI,) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xFF4B1B3F),
      builder: (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: Text(
                  'Selecciona una hora',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: diasSemana.map((String dia) {
                      final List<Padding> lista = horasTotales.map((String h) {
                        final bool ocupada =
                            horasOcupadas[dia]?.contains(h) ?? false;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4,),
                          child: ElevatedButton(
                            onPressed: ocupada
                                ? null
                                : () {
                                    horaSeleccionada = '$dia $h';
                                    Navigator.pop(context);
                                    refreshUI();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ocupada
                                  ? Colors.grey[400]
                                  : const Color(0xFFFFE066),
                              foregroundColor: ocupada
                                  ? Colors.white
                                  : const Color(0xFF4B1B3F),
                              minimumSize: const Size(100, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(h),
                          ),
                        );
                      }).toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 4),
                            child: Text(
                              dia,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,),
                            ),
                          ),
                          Wrap(children: lista),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void confirmarCita(BuildContext context) {
    if (mascotaSeleccionada != null &&
        razonSeleccionada != null &&
        veterinarioSeleccionado != null &&
        fechaSeleccionada != null &&
        horaSeleccionada != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cita agendada exitosamente'),
          backgroundColor: Color(0xFF4B1B3F),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos obligatorios'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
