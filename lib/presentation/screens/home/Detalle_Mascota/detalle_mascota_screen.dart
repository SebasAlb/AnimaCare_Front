import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_info_section.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_historial_section.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/editar_mascota_modal.dart';

import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_eventos_section.dart';

// Version 2
class DetalleMascotaScreen extends StatelessWidget {
  const DetalleMascotaScreen({super.key, required this.mascota});

  final Mascota mascota;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetalleMascotaController>(
      create: (_) => DetalleMascotaController(mascota),
      child: const _DetalleContenido(),
    );
  }
}

class _DetalleContenido extends StatelessWidget {
  const _DetalleContenido();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<DetalleMascotaController>();
    
    Widget _buildTab({
      required BuildContext context,
      required String label,
      required VistaDetalleMascota vista,
      required bool isSelected,
      required ThemeData theme,
    }) => GestureDetector(
          onTap: () {
            context.read<DetalleMascotaController>().vistaActual = vista;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
              ),
            ),
          ),
        );


    Widget _buildToggleTabs() {
      final controller = context.watch<DetalleMascotaController>();
      final theme = Theme.of(context);

      final tabs = {
        VistaDetalleMascota.info: 'Información',
        VistaDetalleMascota.eventos: 'Eventos',
        VistaDetalleMascota.historial: 'Historial',
      };

      final entries = tabs.entries.toList();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < entries.length; i++) ...[
              _buildTab(
                context: context,
                label: entries[i].value,
                vista: entries[i].key,
                isSelected: controller.vistaActual == entries[i].key,
                theme: theme,
              ),
              if (i < entries.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '|',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ],
        ),
      );
    }

    Widget _buildContenido() {
      switch (controller.vistaActual) {
        case VistaDetalleMascota.historial:
          return MascotaHistorialSection(
            historial: controller.historialMedico,
            proximoEvento: controller.proximoEvento,
            fechaProximoEvento: controller.fechaProximoEvento,
          );
        case VistaDetalleMascota.eventos:
          return const MascotaEventosSection();
        case VistaDetalleMascota.info:
        default:
          return MascotaInfoSection(
            nombre: controller.mascota.nombre,
            fotoUrl: controller.mascota.fotoUrl,
            controllers: controller.controllers,
            filtro: controller.filtro,
            onFiltroChange: controller.setFiltro,
            filtroScrollController: controller.filtroScrollController,
            filtroKeys: controller.filtroKeys,
          );
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, controller.mascota); // ← Devuelve la mascota actualizada
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        // ✅ BOTÓN FLOTANTE FIJO
        floatingActionButton: controller.vistaActual == VistaDetalleMascota.info
          ? FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              onPressed: () {
                EditarMascotaModal.show(
                  context,
                  mascota: controller.mascota,
                  controllers: controller.controllers,
                  onGuardar: (m) {
                    controller.mascota = m;
                    controller.notifyListeners();
                  },
                );
              },
              child: const Icon(Icons.edit, color: Colors.white),
            )
          : null,

        body: SafeArea(
          child: Column(
            children: <Widget>[
              CustomHeader(
                petName: controller.mascota.nombre,
                mostrarMascota: true,
              ),
              _buildToggleTabs(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    _buildContenido(), // MascotaInfoSection o MascotaHistorialSection
                  ],
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




