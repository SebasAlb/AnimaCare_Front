import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final isLoggedIn = UserStorage.isLoggedIn();
      if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.homeOwner);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
