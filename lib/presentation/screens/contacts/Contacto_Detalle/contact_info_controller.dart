import 'package:animacare_front/models/veterinario.dart';
import 'package:animacare_front/presentation/screens/contacts/Agendar_Cita/agendar_cita_screen.dart';
import 'package:animacare_front/services/sound_service.dart';
import 'package:flutter/material.dart';

class ContactInfoController {
  void abrirAgendarCita(BuildContext context, Veterinario veterinario) {
    SoundService.playButton();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgendarCitaScreen(
          veterinarioPreseleccionado: veterinario,
        ),
      ),
    );
  }
}
