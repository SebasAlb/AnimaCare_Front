import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/presentation/components/list_extensions.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.veterinario,
    required this.excepciones,
    this.onTap,
  });

  final Veterinario veterinario;
  final List<VeterinarioExcepcion> excepciones;
  final VoidCallback? onTap;

  String _nombreDiaHoy() {
    const dias = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves',
      'Viernes', 'Sábado', 'Domingo'
    ];
    return dias[DateTime.now().weekday - 1];
  }

  String? _horarioDeHoy() {
    final diaHoy = _nombreDiaHoy();
    final detalle = veterinario.horarios.firstWhereOrNull(
          (h) => h.diaSemana == diaHoy,
    );
    if (detalle != null) {
      final inicio = DateTime.parse(detalle.horaInicio).toLocal();
      final fin = DateTime.parse(detalle.horaFin).toLocal();
      return '${_formatoHora(inicio)} - ${_formatoHora(fin)}';
    }
    return null;
  }

  String _estadoHoy() {
    final ahora = DateTime.now();
    final diaHoy = _nombreDiaHoy();

    final horario = veterinario.horarios.firstWhereOrNull(
          (h) => h.diaSemana == diaHoy,
    );

    if (horario == null) return 'No disponible';

    final horaInicio = DateTime(ahora.year, ahora.month, ahora.day,
        DateTime.parse(horario.horaInicio).hour, DateTime.parse(horario.horaInicio).minute);
    final horaFin = DateTime(ahora.year, ahora.month, ahora.day,
        DateTime.parse(horario.horaFin).hour, DateTime.parse(horario.horaFin).minute);

    final estaEnHorario = ahora.isAfter(horaInicio) && ahora.isBefore(horaFin);

    final tieneExcepcion = excepciones.any((e) =>
    e.veterinarioId == veterinario.id &&
        e.fecha.year == ahora.year &&
        e.fecha.month == ahora.month &&
        e.fecha.day == ahora.day &&
        ahora.isAfter(DateTime(ahora.year, ahora.month, ahora.day,
            DateTime.parse(e.horaInicio).hour, DateTime.parse(e.horaInicio).minute)) &&
        ahora.isBefore(DateTime(ahora.year, ahora.month, ahora.day,
            DateTime.parse(e.horaFin).hour, DateTime.parse(e.horaFin).minute)) &&
        e.disponible == false);

    if (!estaEnHorario || tieneExcepcion) return 'No disponible';
    return 'Disponible';
  }


  String _formatoHora(DateTime hora) {
    return '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
  }


  Color _estadoColor(BuildContext context, String estado) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (estado == 'Disponible') {
      return isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32); // Verde
    } else {
      return isDark ? const Color(0xFFB0BEC5) : const Color(0xFF37474F); // Gris 2
    }
  }

  IconData _estadoIcon(String estado) {
    return estado == 'Disponible'
        ? Icons.check_circle_outline
        : Icons.do_not_disturb_on;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estado = _estadoHoy();
    final estadoColor = _estadoColor(context, estado);
    final horarioHoy = _horarioDeHoy();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.cardColor, // anterior: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.primary,
                      image: veterinario.fotoUrl != null && veterinario.fotoUrl!.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(veterinario.fotoUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: veterinario.fotoUrl == null || veterinario.fotoUrl!.isEmpty
                        ? Icon(
                      Icons.person,
                      color: theme.colorScheme.onPrimary,
                      size: 30,
                    )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Veterinario - ${veterinario.rol}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary, // Anterior: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          veterinario.nombreCompleto,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary, // Anterior: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.info_outline, color: theme.colorScheme.primary, /* Anterior: theme.colorScheme.onPrimary,*/),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(_estadoIcon(estado), size: 18, color: estadoColor),
                        const SizedBox(width: 8),
                        Text(
                          estado,
                          style: TextStyle(
                            color: estadoColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (estado == 'Disponible' && horarioHoy != null)
                      Text(
                        horarioHoy,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary.withOpacity(0.6),  // Anterior: theme.colorScheme.onPrimary
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

