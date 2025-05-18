import 'package:flutter/material.dart';
import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_screen.dart';
import 'package:animacare_front/routes/app_routes.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key, required this.mascota});
  final Mascota mascota;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detalleMascota,
          arguments: mascota,
        );

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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  image: mascota.fotoUrl != null && mascota.fotoUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(mascota.fotoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: mascota.fotoUrl == null || mascota.fotoUrl!.isEmpty
                    ? Icon(Icons.pets, size: 50, color: theme.colorScheme.primary)
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
                        mascota.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.secondary.withOpacity(0.6),
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
