import 'package:animacare_front/presentation/screens/add_edit_pets/add_edit_pets_screen.dart';
import 'package:animacare_front/presentation/screens/home_owner/home_owner_screen.dart';
import 'package:animacare_front/presentation/screens/owner_update/owner_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/login/login_screen.dart';
import 'package:animacare_front/presentation/screens/signup/signup_screen.dart';
import 'package:animacare_front/presentation/screens/recommendations/recommendations_screen.dart';
import 'package:animacare_front/presentation/screens/calendar/calendar_screen.dart';
import 'package:animacare_front/presentation/screens/edit_notifications/edit_notifications_screen.dart';
import 'package:animacare_front/presentation/screens/add_event/add_event_screen.dart';
import 'package:animacare_front/presentation/screens/map/map_screen.dart';
import 'package:animacare_front/presentation/screens/medical_history/medical_history_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String recommendations = '/recommendations';
  static const String homeOwner = '/homeowner';
  static const String ownerUpdate = '/ownerupdate';
  static const String addEditPet = './addeditpet';
  static const String calendar = '/calendar';
  static const String editNotifications = '/edit-notifications';
  static const String addEvent = '/add-event';
  static const String map = '/map';
  static const String medicalhistory = '/medicalhistory';


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
      case medicalhistory:
        return MaterialPageRoute(builder: (_) => const medicalhistoryScreen());

      case addEditPet:
        return MaterialPageRoute(builder: (_) => const AddEditPetScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case editNotifications:
        return MaterialPageRoute(builder: (_) => const EditNotificationsScreen());
      case addEvent:
        return MaterialPageRoute(builder: (_) => const AddEventScreen());


      case map:
        return MaterialPageRoute(builder: (_) => MapScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
