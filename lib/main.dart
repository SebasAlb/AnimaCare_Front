import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Inyectamos el controlador con Get.put permanentemente
  Get.put<ThemeController>(ThemeController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Obx en lugar de GetBuilder para reconstruir solo lo necesario
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      return GetMaterialApp(
        title: 'AnimaCare',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
      );
    });
  }
}