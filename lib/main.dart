import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Controlador que dura toda la app
  Get.put<ThemeController>(ThemeController(), permanent: true);

  // Controladores que se usarán solo cuando se necesiten
  Get.lazyPut<EditarPerfilController>(() => EditarPerfilController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      return GetMaterialApp(
        title: 'AnimaCare',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      );
    });
  }
}
