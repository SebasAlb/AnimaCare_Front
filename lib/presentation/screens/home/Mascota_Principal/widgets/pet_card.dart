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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              mascotaActual.nombre,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.brightness == Brightness.dark
                                    ? AppColors.onSurfaceDark
                                    : AppColors.primaryBrand,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.chevron_right,
                            color: theme.brightness == Brightness.dark
                                ? AppColors.onSurfaceDark.withOpacity(0.6)
                                : AppColors.primaryBrand.withOpacity(0.6),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade400),
                      onPressed: () {
                        SoundService.playButton(); // 🔊 Sonido
                        _mostrarConfirmacionEliminar(context);
                      },
                    ),
                  ],
                ),
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
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
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



