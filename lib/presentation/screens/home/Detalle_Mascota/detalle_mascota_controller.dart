import 'package:flutter/material.dart';

class DetalleMascotaController {
  int currentIndex = 0;
  String filtro = 'Todos';
  bool mostrarHistorial = false;

  final ScrollController filtroScrollController = ScrollController();

  final Map<String, GlobalKey> filtroKeys = <String, GlobalKey<State<StatefulWidget>>>{
    'Todos': GlobalKey(),
    'Citas': GlobalKey(),
    'Vacunas': GlobalKey(),
    'Otros': GlobalKey(),
  };

  final Map<String, TextEditingController> controllers = <String, TextEditingController>{
    'Raza': TextEditingController(text: 'Labrador'),
    'Edad': TextEditingController(text: '3 años'),
    'Cumpleaños': TextEditingController(text: '10 de abril'),
    'Peso': TextEditingController(text: '24 kg'),
    'Altura': TextEditingController(text: '60 cm'),
    'Sexo': TextEditingController(text: 'Macho'),
  };

  final Map<String, List<Map<String, String>>> historialMedico = <String, List<Map<String, String>>>{
    'Vacunas': <Map<String, String>>[
      <String, String>{'fecha': '01/01/2023', 'descripcion': 'Vacuna contra moquillo'},
      <String, String>{'fecha': '01/06/2023', 'descripcion': 'Vacuna contra rabia'},
    ],
    'Desparasitaciones': <Map<String, String>>[
      <String, String>{'fecha': '15/03/2023', 'descripcion': 'Desparasitación interna'},
      <String, String>{'fecha': '15/07/2023', 'descripcion': 'Desparasitación externa'},
    ],
    'Controles Generales': <Map<String, String>>[
      <String, String>{'fecha': '10/05/2023', 'descripcion': 'Chequeo general'},
    ],
    'Cirugías': <Map<String, String>>[
      <String, String>{'fecha': '12/12/2022', 'descripcion': 'Esterilización'},
    ],
  };

  final String proximoEvento = 'Vacuna contra moquillo';
  final String fechaProximoEvento = '10/01/2024';

  void setFiltro(String nuevoFiltro) {
    filtro = nuevoFiltro;
  }

  void disposeControllers() {
    for (final TextEditingController controller in controllers.values) {
      controller.dispose();
    }
    filtroScrollController.dispose();
  }
}
