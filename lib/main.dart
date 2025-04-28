import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart'; // Aquí tienes las rutas que vas a usar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AnimaCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Opcional, si quieres usar Material 3
      ),
      initialRoute: AppRoutes.login, // Primera pantalla que se muestra
      onGenerateRoute: AppRoutes.generateRoute, // Cómo se generan las rutas
    );
  }
}
