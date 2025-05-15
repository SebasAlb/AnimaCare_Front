import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animacare_front/presentation/theme/theme_controller.dart';
import 'package:animacare_front/routes/app_routes.dart';

void main() async {
  await GetStorage.init(); // Inicializa GetStorage
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) => GetMaterialApp(
        title: 'AnimaCare',
        debugShowCheckedModeBanner: false,
        builder: (context, child) => AnimatedTheme(
          data: controller.themeMode == ThemeMode.dark ? darkTheme : lightTheme,
          duration: const Duration(milliseconds: 500), // <- transición suave
          curve: Curves.easeInOut,
          child: child!,
        ),
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: controller.themeMode,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
