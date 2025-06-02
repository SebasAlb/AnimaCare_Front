import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animacare_front/presentation/screens/home/Detalle_Mascota/detalle_mascota_controller.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class MascotaInfoSection extends StatelessWidget {
  final String nombre;
  final String fotoUrl;

  const MascotaInfoSection({
    super.key,
    required this.nombre, // ✅ aquí
    required this.fotoUrl,
    required this.controllers,
    required this.filtro,
    required this.onFiltroChange,
    required this.filtroScrollController,
    required this.filtroKeys,
  });


  final Map<String, TextEditingController> controllers;
  final String filtro;
  final void Function(String) onFiltroChange;
  final ScrollController filtroScrollController;
  final Map<String, GlobalKey> filtroKeys;

  void _scrollToFiltro(String key) {
    final BuildContext? context = filtroKeys[key]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            'Información de la mascota',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.primary,

            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Container( //tamaño de la imagen
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: fotoUrl.isNotEmpty
                        ? ClipRRect( // Usa ClipRRect para que la imagen se ajuste al borderRadius
                      borderRadius: BorderRadius.circular(12),
                      child: fotoUrl.startsWith('/') || fotoUrl.startsWith('file')
                          ? Image.file(File(fotoUrl), fit: BoxFit.cover)
                          : Image.network(fotoUrl, fit: BoxFit.cover),
                    )
                        : Icon(
                      Icons.pets, // O el icono que prefieras, por ejemplo, Icons.person
                      size: 70, // Ajusta el tamaño del icono según tu preferencia
                      color: theme.colorScheme.primary, // Color del icono
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.photo_camera,
                          size: 16, color: Colors.white,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              
              const SizedBox(height: 15),
            ],
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: controllers.entries.map((e) {
            final String label = e.key == 'Fecha de nacimiento' ? 'Cumpleaños' : e.key;
            final String value = e.key == 'Fecha de nacimiento'
                ? _formatearCumple(e.value.text)
                : e.value.text;
            final IconData icon = _getIconForLabel(label);

            return _InfoBoxEditable(
              icon: icon,
              label: label,
              value: value,
              theme: theme,
            );
          }).toList(),

        ),
        const SizedBox(height: 60), // espacio final
      ],
    );
  }
  
  String _formatearCumple(String fecha) {
    final partes = fecha.split('/');
    if (partes.length >= 2) {
      return '${partes[0].padLeft(2, '0')}/${partes[1].padLeft(2, '0')}';
    }
    return fecha;
  }

  

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Raza':
        return Icons.pets;
      case 'Edad':
        return Icons.calendar_today;
      case 'Cumpleaños':
        return Icons.cake;
      case 'Peso':
        return Icons.monitor_weight;
      case 'Altura':
        return Icons.height;
      case 'Sexo':
        return Icons.male;
      case 'Especie':
        return Icons.category;

      default:
        return Icons.info;
    }
  }
}

class _InfoBoxEditable extends StatelessWidget {
  const _InfoBoxEditable({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor, // Opacidad de los cuadros de info
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
}

class _EventoCard extends StatelessWidget {
  const _EventoCard({
    required this.icon,
    required this.title,
    required this.date,
  });

  final IconData icon;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,),),
                const SizedBox(height: 4),
                Text(date,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 14),),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white60),
        ],
      ),
    );
  }
  
}

class _FiltroChip extends StatelessWidget {
  const _FiltroChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: onTap,
          child: Chip(
            label: Text(label),
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white,),
            backgroundColor: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide.none,
          ),
        ),
      );
}






