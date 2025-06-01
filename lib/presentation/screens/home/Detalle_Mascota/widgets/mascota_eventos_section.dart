import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/vista_eventos.dart';
import 'package:animacare_front/presentation/screens/calendar/widgets/evento_calendar.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';

class MascotaEventosSection extends StatefulWidget {
  const MascotaEventosSection({super.key});

  @override
  State<MascotaEventosSection> createState() => _MascotaEventosSectionState();
}

class _MascotaEventosSectionState extends State<MascotaEventosSection> {
  final TextEditingController searchController = TextEditingController();

  void mostrarDetallesEvento(EventoCalendar evento) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.dialogBackgroundColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      evento.titulo,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('🗓 Fecha: ${evento.fecha}'),
                  Text('🕒 Hora: ${evento.hora}'),
                  Text('🐾 Mascota: ${evento.mascota}'),
                  Text('👨‍⚕️ Veterinario: ${evento.veterinario}'),
                  Text('📌 Tipo: ${evento.esCita ? 'Cita' : 'Evento'}'),
                  if (evento.estado != null) Text('📋 Estado: ${evento.estado}'),
                  if (evento.descripcion != null)
                    Text('📝 Nota: ${evento.descripcion}'),
                  const SizedBox(height: 24),
                  if (evento.esCita) ...[
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de reagendar cita no implementada aún.'),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_calendar, color: colorScheme.primary),
                      label: Text(
                        'Reagendar cita',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Cita cancelada'),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      label: const Text(
                        'Cancelar cita',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: theme.iconTheme.color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DetalleMascotaController>();
    final List<EventoCalendar> lista = controller.eventosMascota;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Citas y eventos de ${controller.mascota.nombre}',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (controller.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: VistaEventos(
              eventos: lista,
              controller: searchController,
              onTapEvento: mostrarDetallesEvento,
              onSeleccionarFecha: (_) {},
              onAbrirFiltro: null,
            ),
          ),
      ],
    );
  }
}
