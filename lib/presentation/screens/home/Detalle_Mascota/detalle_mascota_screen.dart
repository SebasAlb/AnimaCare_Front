import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_info_section.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/widgets/mascota_historial_section.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';

class DetalleMascotaScreen extends StatefulWidget {
  const DetalleMascotaScreen({super.key});

  @override
  State<DetalleMascotaScreen> createState() => _DetalleMascotaScreenState();
}

class _DetalleMascotaScreenState extends State<DetalleMascotaScreen> {
  final DetalleMascotaController controller = DetalleMascotaController();

  @override
  void dispose() {
    controller.disposeControllers();
    super.dispose();
  }

  Widget _buildToggleTabs(ThemeData theme) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => setState(() => controller.mostrarHistorial = false),
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
                    fontSize: 16,),),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => setState(() => controller.mostrarHistorial = true),
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

  Widget _buildContenido() => controller.mostrarHistorial
      ? MascotaHistorialSection(
          historial: controller.historialMedico,
          proximoEvento: controller.proximoEvento,
          fechaProximoEvento: controller.fechaProximoEvento,
        )
      : MascotaInfoSection(
          controllers: controller.controllers,
          filtro: controller.filtro,
          onFiltroChange: (String f) => setState(() => controller.setFiltro(f)),
          filtroScrollController: controller.filtroScrollController,
          filtroKeys: controller.filtroKeys,
        );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                const CustomHeader(
                  petName: 'Gato 1',
                ),
                _buildToggleTabs(theme),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: <Widget>[_buildContenido()],
                  ),
                ),
              ],
            ),
          ),
        ],
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
    );
  }
}
