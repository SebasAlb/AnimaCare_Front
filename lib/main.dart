import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';
import 'package:animacare_front/presentation/theme/colors.dart'; // Importa tus colores y temas aquí

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Inicializa GetStorage aquí una vez

  // Poner el ThemeController aquí para que esté disponible desde el inicio de forma permanente
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Obtener la instancia del controlador puesta permanentemente
  final ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      // Inicializar con la instancia encontrada. Esto hace que GetBuilder
      // se suscriba a los cambios de themeController.update().
      init: themeController,
      builder: (controller) => GetMaterialApp(
        title: 'AnimaCare',
        debugShowCheckedModeBanner: false,

        // *** AnimatedTheme configurado correctamente, considera ajustar la duración si 500ms es lento ***
        builder: (context, child) => AnimatedTheme(
          data: controller.themeMode == ThemeMode.dark ? darkTheme : lightTheme,
          duration: const Duration(milliseconds: 300), // <-- Puedes reducir esto (ej: 300ms)
          curve: Curves.easeInOut,
          child: child!,
        ),

        // GetMaterialApp también necesita saber los temas para el themeMode
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: controller.themeMode, // <-- Lee el themeMode del controlador

        initialRoute: AppRoutes.login,
        // Si usas Get.toNamed/Get.offAllNamed, es mejor usar getPages en lugar de onGenerateRoute
        // Si DEBES usar onGenerateRoute, asegúrate de que funcione bien con GetX Find/Put.
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}