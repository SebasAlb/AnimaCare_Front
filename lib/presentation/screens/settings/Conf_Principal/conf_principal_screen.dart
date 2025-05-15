import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/settings/Conf_Principal/conf_principal_controller.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfPrincipalController controller = ConfPrincipalController();
    final ThemeController themeController = Get.find();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Ajustes',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 45,
              backgroundColor: theme.cardColor,
              child: Icon(Icons.person, size: 50, color: theme.iconTheme.color),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Mr. Del Conde Mayhoccer',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Mi cuenta', theme),
            _buildSettingCard(
                context, Icons.person, 'Mi perfil', controller, theme,),
            _buildSectionTitle('Preferencias', theme),
            _buildThemeSwitchCard(context, themeController, theme),
            _buildSectionTitle('Sesión', theme),
            _buildSettingCard(
                context, Icons.logout, 'Cerrar sesión', controller, theme,),
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

  Widget _buildSectionTitle(String title, ThemeData theme) => Padding(
        padding: const EdgeInsets.only(left: 20, top: 18, bottom: 8),
        child: Text(
          title,
          style:
              theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      );

  Widget _buildSettingCard(
    BuildContext context,
    IconData icon,
    String title,
    ConfPrincipalController controller,
    ThemeData theme,
  ) =>
      Card(
        color: theme.cardColor,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, color: theme.iconTheme.color),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          trailing: Icon(Icons.chevron_right, color: theme.iconTheme.color),
          onTap: () => controller.onTapSetting(context, title),
        ),
      );

  Widget _buildThemeSwitchCard(
    BuildContext context,
    ThemeController themeController,
    ThemeData theme,
  ) => Card(
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.dark_mode, color: theme.iconTheme.color),
        title: Text(
          'Tema oscuro',
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: GetBuilder<ThemeController>(
          builder: (ThemeController controller) => Switch(
            value: controller.themeMode == ThemeMode.dark,
            onChanged: controller.toggleTheme,
            activeColor: theme.colorScheme.primary,
          ),
        ),
      ),
    );
}
