import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animacare_front/storage/user_storage.dart';
import 'package:animacare_front/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future.delayed(const Duration(milliseconds: 600), () {
      final isLoggedIn = UserStorage.isLoggedIn();
      if (isLoggedIn) {
        Get.offAllNamed(AppRoutes.homeOwner);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}