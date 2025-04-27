import 'package:animacare_front/presentation/screens/home_owner/home_owner_screen.dart';
import 'package:animacare_front/presentation/screens/owner_update/owner_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/login/login_screen.dart';
import 'package:animacare_front/presentation/screens/signup/signup_screen.dart';
import 'package:animacare_front/presentation/screens/recommendations/recommendations_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String recommendations = '/recommendations';
  static const String homeOwner = '/homeowner';
  static const String ownerUpdate = '/ownerupdate';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case homeOwner:
        return MaterialPageRoute(builder: (_) => const HomeOwnerScreen());
      case ownerUpdate:
        return MaterialPageRoute(builder: (_) => const UserOwnerScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case recommendations:
        return MaterialPageRoute(builder: (_) => const RecommendationsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
