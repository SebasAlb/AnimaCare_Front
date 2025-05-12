import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/components/custom_header.dart';
// import '../Editar_Perfil/editar_perfil_screen.dart';
import 'package:animacare_front/presentation/screens/settings/Conf_Principal/conf_principal_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfPrincipalController controller = ConfPrincipalController();

    return Scaffold(
      backgroundColor: const Color(0xFFD5F3F1),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const CustomHeader(
              petName: 'Gato 1',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Configuraciones',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14746F),
                  ),
                ),
              ),
            ),
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Mr. Del Conde Mayhoccer',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Mi cuenta'),
            _buildSettingCard(context, Icons.person, 'Mi perfil', controller),
            _buildSectionTitle('Preferencias'),
            _buildSettingCard(
                context, Icons.notifications, 'Notificaciones', controller,),
            _buildSettingCard(
                context, Icons.alarm, 'Recordatorios', controller,),
            _buildSettingCard(context, Icons.language, 'Idioma', controller),
            _buildSettingCard(
                context, Icons.dark_mode, 'Tema oscuro', controller,),
            _buildSectionTitle('Soporte y privacidad'),
            _buildSettingCard(context, Icons.privacy_tip,
                'Política de privacidad', controller,),
            _buildSettingCard(
                context, Icons.share, 'Compartir con veterinario', controller,),
            _buildSettingCard(
                context, Icons.help_outline, 'Ayuda y soporte', controller,),
            _buildSectionTitle('Sesión'),
            _buildSettingCard(
                context, Icons.logout, 'Cerrar sesión', controller,),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3,
        onTap: (index) {
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
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(left: 20, top: 18, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF14746F),
        ),
      ),
    );

  Widget _buildSettingCard(BuildContext context, IconData icon, String title,
      ConfPrincipalController controller,) => Card(
      color: const Color(0xFF1BB0A2),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () => controller.onTapSetting(context, title),
      ),
    );
}
