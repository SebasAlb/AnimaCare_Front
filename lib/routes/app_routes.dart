import 'package:animacare_front/presentation/screens/add_edit_pets/add_edit_pets_screen.dart';
import 'package:animacare_front/presentation/screens/home_owner/home_owner_screen.dart';
import 'package:animacare_front/presentation/screens/owner_update/owner_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/login/login_screen.dart';
import 'package:animacare_front/presentation/screens/signup/signup_screen.dart';
import 'package:animacare_front/presentation/screens/recommendations/recommendations_screen.dart';

// NUEVO: Importaciones de tus pantallas
import 'package:animacare_front/presentation/screens/calendar/calendar_screen.dart'; // << NUEVO
import 'package:animacare_front/presentation/screens/edit_notifications/edit_notifications_screen.dart'; // << NUEVO
import 'package:animacare_front/presentation/screens/add_event/add_event_screen.dart'; // << NUEVO

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String recommendations = '/recommendations';
  static const String homeOwner = '/homeowner';
  static const String ownerUpdate = '/ownerupdate';
  static const String addEditPet = './addeditpet';
  static const String calendar = '/calendar'; // << NUEVO
  static const String editNotifications = '/edit-notifications'; // << NUEVO
  static const String addEvent = '/add-event'; // << NUEVA RUTA


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

      case addEditPet:
        return MaterialPageRoute(builder: (_) => const AddEditPetScreen());
      case calendar: // << NUEVO
        return MaterialPageRoute(builder: (_) => const CalendarScreen()); // << NUEVO
      case editNotifications: // << NUEVO
        return MaterialPageRoute(builder: (_) => const EditNotificationsScreen()); // << NUEVO
      case addEvent:
        return MaterialPageRoute(builder: (_) => const AddEventScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
