import 'dart:io';

import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/presentation/theme/colors.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/services/sound_service.dart';

class PetCard extends StatefulWidget {
  const PetCard({super.key, required this.mascota});
  final Mascota mascota;

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        mascotaActual.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.brightness == Brightness.dark
                              ? AppColors.onSurfaceDark // blanco suave
                              : AppColors.primaryBrand, // azul profundo
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
            ),
          ],
        ),
      ),
    );
  }
}
