import 'dart:io';

import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/services/sound_service.dart';


class PetCard extends StatefulWidget {
  const PetCard({super.key, required this.mascota, required this.onEliminada});
  final Mascota mascota;
  final VoidCallback onEliminada;

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  late Mascota mascotaActual;

  @override
  void initState() {
    super.initState();
    mascotaActual = widget.mascota;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      
      onTap: () async {
        SoundService.playButton();
        final Object? resultado = await Navigator.pushNamed(
          context,
          AppRoutes.detalleMascota,
          arguments: mascotaActual,
        );
        SoundService.playButton(); // Sonido al regresar a Home

        if (resultado is Mascota) {
          setState(() {
            mascotaActual = resultado;
          });
        }
      },

      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  image: mascotaActual.fotoUrl.isNotEmpty
                      ? DecorationImage(
                          image: mascotaActual.fotoUrl.startsWith('/')
                              ? FileImage(File(mascotaActual.fotoUrl))
                              : NetworkImage(mascotaActual.fotoUrl)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: mascotaActual.fotoUrl.isEmpty
                    ? Icon(Icons.pets,
                        size: 50, color: theme.colorScheme.primary,)
                    : null,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Botón eliminar con fondo rojo oscuro
                  Container(
                    width: 45,
                    decoration: const BoxDecoration(
                      color: Colors.red, // Puedes ajustar al rojo más oscuro que prefieras
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_forever_rounded, color: Colors.white),
                      onPressed: () {
                        SoundService.playButton(); // 🔊 Sonido
                        _mostrarConfirmacionEliminar(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500, // Fondo más oscurito
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              mascotaActual.nombre,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _mostrarConfirmacionEliminar(BuildContext context) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar mascota'),
        content: Text('¿Seguro que deseas eliminar a ${mascotaActual.nombre}? Esta acción es reversible.'),
        actions: [
          TextButton(
            onPressed: () {
              SoundService.playButton(); // 🔊 Sonido
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      widget.onEliminada();
    }

  }

}



