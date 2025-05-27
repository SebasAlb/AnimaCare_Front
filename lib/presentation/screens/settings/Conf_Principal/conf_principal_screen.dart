import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/settings/Conf_Principal/conf_principal_controller.dart';
import 'package:get/get.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/models/dueno.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  final ConfPrincipalController controller = ConfPrincipalController();
  final ThemeController themeController = Get.find();
  late final Dueno? dueno;

  @override
  void initState() {
    super.initState();
    dueno = UserStorage.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, AppRoutes.homeOwner);
        return false;
      },
      child: Scaffold(
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
                  '${dueno?.nombre ?? ''} ${dueno?.apellido ?? ''}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Mi cuenta', theme),
              _buildSettingCard(
                context,
                Icons.person,
                'Mi perfil',
                controller,
                theme,
              ),
              _buildSectionTitle('Preferencias', theme),
              _buildThemeSwitchCard(context, theme),
              _buildSectionTitle('Sesión', theme),
              _buildSettingCard(
                context,
                Icons.logout,
                'Cerrar sesión',
                controller,
                theme,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: 3,
          onTap: (index) {
            if (index != 3) {
              Navigator.pushReplacementNamed(
                context,
                _getRouteForIndex(index),
              );
            }
          },
        ),
      ),
    );
  }

  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.homeOwner;
      case 1:
        return AppRoutes.contactsP;
      case 2:
        return AppRoutes.calendar;
      default:
        return AppRoutes.settingsP;
    }
  }

  Widget _buildSectionTitle(String title, ThemeData theme) => Padding(
        padding: const EdgeInsets.only(left: 20, top: 18, bottom: 8),
        child: Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
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
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
          onTap: () => controller.onTapSetting(context, title),
        ),
      );

  Widget _buildThemeSwitchCard(BuildContext context, ThemeData theme) {
    return Card(
      color: theme.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
        title: Text(
          'Tema oscuro',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
        trailing: GetBuilder<ThemeController>(
          builder: (controller) => Switch(
            value: controller.themeMode == ThemeMode.dark,
            onChanged: (bool isDark) => _mostrarAnimacionCascada(context, isDark),
            activeColor: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _mostrarAnimacionCascada(BuildContext context, bool isDark) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    overlayEntry = OverlayEntry(
      builder: (_) => Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: animation,
          child: Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: const Icon(
              Icons.auto_mode,
              size: 80,
              color: Colors.amber,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.find<ThemeController>().toggleTheme(isDark);

        Future.delayed(const Duration(milliseconds: 150), () {
          overlayEntry.remove();
          controller.dispose();
        });
      }
    });
  }
}

