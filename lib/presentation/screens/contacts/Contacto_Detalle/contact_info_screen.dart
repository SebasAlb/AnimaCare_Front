import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:intl/intl.dart';
import 'package:animacare_front/presentation/components/list_extensions.dart';

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
    final now = DateTime.now();

    final excepcionesRelevantes = excepciones.where(
      (e) =>
        e.veterinarioId == veterinario.id &&
        e.fechaFin.isAfter(DateTime.now()),
    ).toList();


    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.cardColor, //original: colorScheme.primary
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const CustomHeader(
              nameScreen: 'Contactos',
              isSecondaryScreen: true,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.onPrimary.withOpacity(0.2),
                    width: 8,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Veterinario',
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
                          color: theme.colorScheme.primary, // original: theme.colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 25),
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: theme.colorScheme.primary, //original: theme.cardColor,
                        backgroundImage: veterinario.fotoUrl.isNotEmpty
                            ? NetworkImage(veterinario.fotoUrl)
                            : null,
                        child: veterinario.fotoUrl.isEmpty
                            ? Icon(Icons.person, size: 60, color: theme.cardColor /*color: theme.iconTheme.color*/)
                            : null,
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

                      // ✅ Mostrar disponibilidad primero
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
                          final bool esHoy = DateTime.now().isAfter(e.fechaInicio) && DateTime.now().isBefore(e.fechaFin);
                          final Color fondo = esHoy ? Colors.redAccent.withOpacity(0.1) : Colors.amber.withOpacity(0.15);
                          final Color icono = esHoy ? Colors.redAccent : Colors.amber[700]!;
                          final String textoEstado = esHoy ? 'No disponible por' : 'No estará disponible por';

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
                                    'Desde: ${DateFormat('dd/MM/yyyy HH:mm').format(e.fechaInicio)}\n'
                                    'Hasta: ${DateFormat('dd/MM/yyyy HH:mm').format(e.fechaFin)}',
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
                          color: theme.colorScheme.primary.withOpacity(0.1),/*original: theme.colorScheme.onPrimary*/
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: HorarioTable(horarios: veterinario.horario),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 16),
          child: FloatingActionButton.extended(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: const Icon(Icons.event_available),
            label: const Text('Agendar Cita'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AgendarCitaScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoLinea(ThemeData theme, IconData icon, String text) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: theme.colorScheme.primary, /*original: theme.colorScheme.secondary,*/ size: 20),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      );
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
                      color: theme.colorScheme.primary, //original: theme.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary, // original: theme.colorScheme.onPrimary,
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










