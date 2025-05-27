import 'package:animacare_front/models/mascota.dart';
import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/models/veterinario_excepcion.dart';

import 'package:animacare_front/presentation/screens/calendar/calendar_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contact_Principal/contacts_screen.dart';
import 'package:animacare_front/presentation/screens/contacts/Contacto_Detalle/contact_info_screen.dart';
import 'package:animacare_front/presentation/screens/home/Agregar_Mascota/agregar_mascota_screen.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_screen.dart';
import 'package:animacare_front/presentation/screens/home/Mascota_Principal/home_screen.dart';
import 'package:animacare_front/presentation/screens/login/login_screen.dart';
import 'package:animacare_front/presentation/screens/settings/Conf_Principal/conf_principal_screen.dart';
import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_controller.dart';
import 'package:animacare_front/presentation/screens/settings/Editar_Perfil/editar_perfil_screen.dart';
import 'package:animacare_front/presentation/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:animacare_front/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';

  static const String login = '/login';
  static const String signup = '/signup';

  static const String homeOwner = '/homeowner';
  static const String homeDetails = './details_pet';
  static const String homeAdd = './addpet';
  static const String detalleMascota = '/detalle_mascota';

  static const String contactsP = '/contacts';
  static const String contactInfo = '/contact_info';
  static const String agendarCita = '/agendar_cita';

  static const String calendar = '/calendar';

  static const String settingsP = '/settings';
  static const String settingsEditProfile = '/settings/editProfile';

  static const String editNotifications = '/edit_notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case homeOwner:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case detalleMascota:
        final Mascota mascota = settings.arguments as Mascota;
        return MaterialPageRoute(
          builder: (_) => DetalleMascotaScreen(mascota: mascota),
        );
      case homeAdd:
        return MaterialPageRoute(builder: (_) => const AgregarMascotaScreen());

      case contactsP:
        return MaterialPageRoute(builder: (_) => const ContactsScreen());
      case contactInfo:
        final args = settings.arguments as Map<String, dynamic>;
        final veterinario = args['veterinario'] as Veterinario;
        final excepciones = args['excepciones'] as List<VeterinarioExcepcion>;
        return MaterialPageRoute(
          builder: (_) => ContactInfoScreen(
            veterinario: veterinario,
            excepciones: excepciones,
          ),
        );
      case agendarCita:
        return MaterialPageRoute(builder: (_) => const AgendarCitaScreen());

      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());

      case settingsP:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case settingsEditProfile:
        return GetPageRoute(
          page: () => const EditarPerfilScreen(),
          binding: BindingsBuilder(() {
            Get.put(EditarPerfilController());
          }),
        );


      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
    }
  }
}
