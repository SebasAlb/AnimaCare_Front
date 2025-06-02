import 'package:animacare_front/services/sound_service.dart';
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
      return e.veterinarioId == veterinario.id &&
            fin.isAfter(DateTime.now()) &&
            e.motivo != 'Cita';
    }).toList();


    final grupos = agruparExcepcionesPorRango(excepcionesRelevantes);


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
                      ...grupos.map((grupo) {
                        final desde = grupo['desde'] as DateTime;
                        final hasta = grupo['hasta'] as DateTime;
                        final String motivo = grupo['motivo'];
                        final TimeOfDay horaMin = grupo['horaMin'];
                        final TimeOfDay horaMax = grupo['horaMax'];

                        final now = DateTime.now();
                        final DateTime desdeConHora = DateTime(desde.year, desde.month, desde.day, horaMin.hour, horaMin.minute);
                        final DateTime hastaConHora = DateTime(hasta.year, hasta.month, hasta.day, horaMax.hour, horaMax.minute);

                        final bool esHoy = now.year == desde.year && now.month == desde.month && now.day == desde.day;
                        final bool yaEmpezo = now.isAfter(desdeConHora);
                        final bool aunNoEmpieza = esHoy && now.isBefore(desdeConHora);

                        Color fondo;
                        String textoEstado;

                        if (yaEmpezo && now.isBefore(hastaConHora)) {
                          fondo = const Color.fromARGB(255, 218, 71, 71); // rojo - en curso
                          textoEstado = 'No disponible por';
                        } else if (aunNoEmpieza) {
                          fondo = const Color.fromARGB(255, 255, 193, 7); // amarillo - es hoy pero aún no inicia
                          textoEstado = 'Estará ausente por';
                        } else {
                          fondo = const Color.fromARGB(255, 248, 187, 3); // naranja - futuro
                          textoEstado = 'No estará disponible por';
                        }       
                        final Color icono = const Color.fromARGB(255, 255, 255, 255);
                        final String horarioInicio = grupo['horaInicio'] != null
                            ? (grupo['horaInicio'] as TimeOfDay).format(context)
                            : horaMin.format(context);

                        final String horarioFin = grupo['horaFin'] != null
                            ? (grupo['horaFin'] as TimeOfDay).format(context)
                            : horaMax.format(context);


                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: fondo,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: theme.colorScheme.onPrimary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: icono,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$textoEstado: ',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '$motivo\n',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onPrimary,
                                        ),
                                      ),
                                      if (desde == hasta) ...[
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${DateFormat('dd/MM/yyyy').format(desde)}\n',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Horario: ',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '$horarioInicio - $horarioFin',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                        ),
                                      ] else ...[
                                        TextSpan(
                                          text: 'Fecha:\n',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Desde el ${DateFormat('dd/MM/yyyy').format(desde)} a las $horarioInicio\n',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Hasta el ${DateFormat('dd/MM/yyyy').format(hasta)} a las $horarioFin',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ],
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
          SoundService.playButton();
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


List<Map<String, dynamic>> agruparExcepcionesPorRango(List<VeterinarioExcepcion> excepciones) {
  final List<Map<String, dynamic>> grupos = [];

  final ordenadas = [...excepciones]..sort((a, b) => a.fecha.compareTo(b.fecha));

  for (int i = 0; i < ordenadas.length; i++) {
    final actual = ordenadas[i];
    if (!actual.disponible) {
      DateTime inicioFecha = actual.fecha;
      DateTime finFecha = actual.fecha;
      String motivo = actual.motivo;

      // Convertir horaInicio y horaFin del primer día
      TimeOfDay horaMin = _parseHora(actual.horaInicio);
      TimeOfDay horaMax = _parseHora(actual.horaFin);

      while (i + 1 < ordenadas.length) {
        final sig = ordenadas[i + 1];
        final esConsecutiva = sig.fecha.difference(finFecha).inDays == 1;
        final mismoMotivo = sig.motivo == motivo && !sig.disponible;

        if (esConsecutiva && mismoMotivo) {
          finFecha = sig.fecha;

          // Actualizar hora mínima y máxima si aplica
          final hIni = _parseHora(sig.horaInicio);
          final hFin = _parseHora(sig.horaFin);

          if (_horaEsAntes(hIni, horaMin)) horaMin = hIni;
          if (_horaEsAntes(horaMax, hFin)) horaMax = hFin;

          i++;
        } else {
          break;
        }
      }

      grupos.add({
        'desde': inicioFecha,
        'hasta': finFecha,
        'motivo': motivo,
        'horaMin': horaMin,
        'horaMax': horaMax,
        'horaInicio': _parseHora(actual.horaInicio), // hora del primer día
        'horaFin': _parseHora(ordenadas[i].horaFin), // hora del último día (posición actual del for)
      });

    }
  }

  return grupos;
}

TimeOfDay _parseHora(String isoTime) {
  final time = DateTime.parse(isoTime);
  return TimeOfDay(hour: time.hour, minute: time.minute);
}

bool _horaEsAntes(TimeOfDay a, TimeOfDay b) {
  return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
}

