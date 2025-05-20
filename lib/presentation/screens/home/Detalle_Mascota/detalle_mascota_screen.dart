import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_info_section.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_historial_section.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';

// Version 2
class DetalleMascotaScreen extends StatelessWidget {
  const DetalleMascotaScreen({super.key, required this.mascota});

  final Mascota mascota;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<DetalleMascotaController>(
      create: (_) => DetalleMascotaController(mascota),
      child: const _DetalleContenido(),
    );
}

class _DetalleContenido extends StatelessWidget {
  const _DetalleContenido();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DetalleMascotaController controller = context.watch<DetalleMascotaController>();

    Widget buildToggleTabs() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => controller.mostrarHistorial = false,
                child: Text(
                  'Información',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: !controller.mostrarHistorial
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('|',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    fontSize: 16,
                  ),),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => controller.mostrarHistorial = true,
                child: Text(
                  'Historial',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: controller.mostrarHistorial
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        );

    Widget buildContenido() => controller.mostrarHistorial
        ? MascotaHistorialSection(
            historial: controller.historialMedico,
            proximoEvento: controller.proximoEvento,
            fechaProximoEvento: controller.fechaProximoEvento,
          )
        : MascotaInfoSection(
            nombre: controller.mascota.nombre, // ← usa el valor actualizado
            fotoUrl: controller.mascota.fotoUrl,
            controllers: controller.controllers,
            filtro: controller.filtro,
            onFiltroChange: controller.setFiltro,
            filtroScrollController: controller.filtroScrollController,
            filtroKeys: controller.filtroKeys,
          );

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context, controller.mascota,); // ← Devuelve la mascota actualizada
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CustomHeader(
                petName:
                    controller.mascota.nombre, // ← usa el nombre actualizado
              ),
              buildToggleTabs(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[buildContenido()],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: 0,
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, AppRoutes.homeOwner);
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.contactsP);
                break;
              case 2:
                Navigator.pushNamed(context, AppRoutes.calendar);
                break;
              case 3:
                Navigator.pushNamed(context, AppRoutes.settingsP);
                break;
            }
          },
        ),
      ),
    );
  }
}
