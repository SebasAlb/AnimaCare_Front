import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ContactInfoScreen extends StatelessWidget {
  final Veterinario veterinario;
  final List<VeterinarioExcepcion> excepciones;

  const ContactInfoScreen({
    super.key,
    required this.veterinario,
    required this.excepciones,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final excepcionesRelevantes = excepciones.where((e) {
      final inicio = DateTime(
        e.fecha.year,
        e.fecha.month,
        e.fecha.day,
        DateTime.parse(e.horaInicio).hour,
        DateTime.parse(e.horaInicio).minute,
      );
      final fin = DateTime(
        e.fecha.year,
        e.fecha.month,
        e.fecha.day,
        DateTime.parse(e.horaFin).hour,
        DateTime.parse(e.horaFin).minute,
      );
      return e.veterinarioId == veterinario.id && fin.isAfter(DateTime.now());
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomHeader(
              nameScreen: 'Contactos',
              isSecondaryScreen: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Veterinario - ${veterinario.rol}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      veterinario.nombreCompleto,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 25),
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: theme.colorScheme.primary,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(65),
                        child: veterinario.fotoUrl.isNotEmpty
                            ? Image.network(
                          veterinario.fotoUrl,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 60,
                            color: theme.cardColor,
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 60,
                          color: theme.cardColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Column(
                      children: <Widget>[
                        _infoLinea(theme, Icons.phone, veterinario.telefono),
                        const SizedBox(height: 8),
                        _infoLinea(theme, Icons.email, veterinario.correo),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (excepcionesRelevantes.isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Próximas ausencias',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...excepcionesRelevantes.map((e) {
                        final inicio = DateTime(
                          e.fecha.year,
                          e.fecha.month,
                          e.fecha.day,
                          DateTime.parse(e.horaInicio).hour,
                          DateTime.parse(e.horaInicio).minute,
                        );
                        final fin = DateTime(
                          e.fecha.year,
                          e.fecha.month,
                          e.fecha.day,
                          DateTime.parse(e.horaFin).hour,
                          DateTime.parse(e.horaFin).minute,
                        );
                        final bool esHoy = DateTime.now().isAfter(inicio) && DateTime.now().isBefore(fin);
                        final Color fondo = esHoy
                            ? const Color.fromARGB(255, 218, 71, 71)
                            : Colors.amber.withOpacity(0.15);
                        final Color icono = esHoy
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : Colors.amber[700]!;
                        final String textoEstado =
                        esHoy ? 'No disponible por' : 'No estará disponible por';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: fondo,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: icono),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '$textoEstado: ${e.motivo}\n'
                                      'Desde: ${DateFormat('dd/MM/yyyy HH:mm').format(inicio)}\n'
                                      'Hasta: ${DateFormat('dd/MM/yyyy HH:mm').format(fin)}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: icono,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 25),
                    ],
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Horario de atención',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: HorarioTable(
                        horarios: _generarMapaHorarios(veterinario),
                      ),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoLinea(ThemeData theme, IconData icon, String text) => Builder(
    builder: (BuildContext context) {
      return InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: text));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 6),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      );
    },
  );

  Map<String, String> _generarMapaHorarios(Veterinario vet) {
    final Map<String, String> mapa = {};
    for (var h in vet.horarios) {
      final horaInicio = h.horaInicio.split('T').last.substring(0, 5); // HH:mm
      final horaFin = h.horaFin.split('T').last.substring(0, 5);       // HH:mm
      mapa[h.diaSemana] = '$horaInicio - $horaFin';
    }
    const dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    for (var dia in dias) {
      mapa.putIfAbsent(dia, () => 'Cerrado');
    }
    return mapa;
  }
}

class HorarioTable extends StatelessWidget {
  const HorarioTable({super.key, required this.horarios});
  final Map<String, String> horarios;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: horarios.entries
          .map(
            (MapEntry<String, String> entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                entry.key,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              Text(
                entry.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }
}
