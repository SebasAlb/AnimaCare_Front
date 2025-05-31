import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/screens/home/Mascota_Principal/home_controller.dart';
import 'package:animacare_front/presentation/screens/home/Mascota_Principal/widgets/pet_card.dart';
import 'package:animacare_front/presentation/components/exit_dialog.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final bool shouldExit = await ExitDialog.show();
          if (shouldExit) {
            Get.back();
            // O quizás SystemNavigator.pop();
          }
        }
      },
      child: ChangeNotifierProvider(
        create: (_) {
          final HomeController controller = HomeController();
          controller.cargarMascotasDesdeApi();// Datos quemados, reemplazables por DB
          return controller;
        },
        child: Consumer<HomeController>(
          builder: (context, controller, _) => Stack(
            children: [
              Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const CustomHeader(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text(
                          'Mascotas ',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: controller.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : RefreshIndicator(
                                onRefresh: () async {
                                  controller.limpiarMascotasCache();
                                  await controller.cargarMascotasDesdeApi();
                                },
                                child: controller.mascotas.isEmpty
                                    ? ListView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        children: const [
                                          SizedBox(height: 100),
                                          Center(child: Text('No tienes mascotas registradas')),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: GridView.count(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          padding: const EdgeInsets.only(bottom: 100),
                                          children: controller.mascotas.map((Mascota m) {
                                            return Consumer<HomeController>(
                                              builder: (context, controller, _) => PetCard(
                                                mascota: m,
                                                onEliminada: () async {
                                                  await controller.eliminarMascotaConEventos(m);
                                                },
                                              ),
                                            );
                                          }).toList(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () => controller.onAgregarMascota(context),
                  backgroundColor: theme.colorScheme.primary,
                  icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
                  label: Text(
                    'Agregar mascota',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                bottomNavigationBar: CustomNavBar(
                  currentIndex: 0,
                  onTap: (int index) {
                    switch (index) {
                      case 0:
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
              if (controller.isEliminando)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}










