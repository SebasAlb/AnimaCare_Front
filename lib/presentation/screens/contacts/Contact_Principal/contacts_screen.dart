import 'package:animacare_front/storage/veterinarian_storage.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/screens/contacts/Contact_Principal/contacts_controller.dart';
import 'package:animacare_front/presentation/screens/contacts/Contact_Principal/widget/contact_card.dart';
import 'package:animacare_front/routes/app_routes.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactsController controller = ContactsController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      await controller.cargarVeterinarios();
    } catch (e) {
      print('Error al cargar veterinarios: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.homeOwner);
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const CustomHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Contactos',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                  onRefresh: () async {
                    setState(() => isLoading = true);
                    // Limpia la caché para forzar recarga desde el backend
                    VeterinariosStorage.clearVeterinarios();
                    await cargarDatos();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.contactos.length,
                    itemBuilder: (context, index) {
                      final vet = controller.contactos[index];
                      return ContactCard(
                        veterinario: vet,
                        excepciones: controller.excepciones,
                        onTap: () => controller.abrirDetalle(context, vet),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => controller.abrirAgendarCita(context),
          backgroundColor: theme.colorScheme.primary,
          icon: Icon(Icons.event_available, color: theme.colorScheme.onPrimary),
          label: Text(
            'Agendar Cita',
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: 1,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, AppRoutes.homeOwner);
                break;
              case 2:
                Navigator.pushReplacementNamed(context, AppRoutes.calendar);
                break;
              case 3:
                Navigator.pushReplacementNamed(context, AppRoutes.settingsP);
                break;
            }
          },
        ),
      ),
    );
  }
}

