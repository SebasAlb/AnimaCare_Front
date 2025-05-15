import 'package:flutter/material.dart';

class MascotaInfoSection extends StatelessWidget {
  const MascotaInfoSection({
    super.key,
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

  void _abrirModalEdicion(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController nombreController = TextEditingController(text: 'Firulais');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Editar información',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/perfil_mascota.png'),
                  ),
                  FloatingActionButton.small(
                    backgroundColor: theme.colorScheme.primary,
                    onPressed: () {},
                    child: const Icon(Icons.photo_camera, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _campoTexto('Nombre', nombreController, theme),
              ...controllers.entries.map((e) => _campoTexto(e.key, e.value, theme)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Cambios guardados correctamente'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Text(
            'Información de la mascota',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/perfil_mascota.png'),
                        fit: BoxFit.cover,
                      ),
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
                      child: const Icon(Icons.photo_camera, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 320,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          'Firulais',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => _abrirModalEdicion(context),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.edit, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
          children: controllers.entries
              .map((e) => _InfoBoxEditable(
            icon: _getIconForLabel(e.key),
            label: e.key,
            value: e.value.text,
            theme: theme,
          ))
              .toList(),
        ),
        const SizedBox(height: 30),
        _buildEventosImportantes(theme),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildEventosImportantes(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.event, color: theme.colorScheme.primary, size: 28),
              const SizedBox(width: 10),
              Text(
                'Eventos importantes',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar evento...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: filtroScrollController,
            child: Row(
              children: filtroKeys.entries.map((entry) {
                return AnimatedContainer(
                  key: entry.value,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: _FiltroChip(
                    label: entry.key,
                    selected: filtro == entry.key,
                    onTap: () {
                      onFiltroChange(entry.key);
                      _scrollToFiltro(entry.key);
                    },
                    theme: theme,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 20),
          const _EventoCard(icon: Icons.calendar_today, title: 'Cita veterinaria', date: '15 de mayo de 2025'),
          const _EventoCard(icon: Icons.vaccines, title: 'Vacuna anual', date: '1 de junio de 2025'),
          const _EventoCard(icon: Icons.cake, title: 'Cumpleaños', date: '10 de abril de 2026'),
          const _EventoCard(icon: Icons.medication, title: 'Rutina de medicina', date: 'Cada 8 horas'),
          const _EventoCard(icon: Icons.shower, title: 'Día de baño', date: 'Todos los sábados'),
          const _EventoCard(icon: Icons.cleaning_services, title: 'Limpieza dental', date: 'Mensual'),
          const _EventoCard(icon: Icons.directions_walk, title: 'Paseo especial', date: 'Domingo 9 AM'),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Raza':
        return Icons.pets;
      case 'Edad':
        return Icons.cake;
      case 'Cumpleaños':
        return Icons.calendar_today;
      case 'Peso':
        return Icons.monitor_weight;
      case 'Altura':
        return Icons.height;
      case 'Sexo':
        return Icons.male;
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
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(16),
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
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
    final theme = Theme.of(context);
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
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.white70, fontSize: 14)),
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
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    ),
  );
}
