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
                const Text(
                  'Editar información',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14746F),
                  ),
                ),
                const SizedBox(height: 20),

                /// Foto
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage:
                          AssetImage('assets/images/perfil_mascota.png'),
                    ),
                    FloatingActionButton.small(
                      backgroundColor: const Color(0xFF1BB0A2),
                      onPressed: () {
                        // Lógica para elegir cámara o galería
                      },
                      child: const Icon(Icons.photo_camera, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _campoTexto('Nombre', nombreController),
                ...controllers.entries.map((MapEntry<String, TextEditingController> entry) => _campoTexto(entry.key, entry.value)),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar cambios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14746F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cambios guardados correctamente'),
                        backgroundColor: Color(0xFF14746F),
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

  Widget _campoTexto(String label, TextEditingController controller) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFD5F3F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Center(
          child: Text(
            'Información de la mascota',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF14746F),
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// Avatar + Nombre + Botón
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
                      color: Colors.white,
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
                        color: const Color(0xFF1BB0A2),
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
              Container(
                width: 320,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    /// Nombre
                    const Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          'Firulais',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14746F),
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),

                    /// Botón
                    Expanded(
                      child: InkWell(
                        onTap: () => _abrirModalEdicion(context),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF14746F),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.edit, color: Colors.white, size: 24),
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

        /// Cuadraditos
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: controllers.entries.map((MapEntry<String, TextEditingController> entry) => _InfoBoxEditable(
              icon: _getIconForLabel(entry.key),
              label: entry.key,
              value: entry.value.text,
            ),).toList(),
        ),
        const SizedBox(height: 30),

        /// Eventos
        _buildEventosImportantes(),
        const SizedBox(height: 40),
      ],
    );

  Widget _buildEventosImportantes() => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
          const Row(
            children: <Widget>[
              Icon(Icons.event, color: Color(0xFF14746F), size: 28),
              SizedBox(width: 10),
              Text(
                'Eventos importantes',
                style: TextStyle(
                  color: Color(0xFF14746F),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar evento...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFD5F3F1),
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
              children: filtroKeys.entries.map((MapEntry<String, GlobalKey<State<StatefulWidget>>> entry) => AnimatedContainer(
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
                  ),
                ),).toList(),
            ),
          ),
          const Divider(color: Colors.black12, height: 20),
          const _EventoCard(
              icon: Icons.calendar_today,
              title: 'Cita veterinaria',
              date: '15 de mayo de 2025',),
          const _EventoCard(
              icon: Icons.vaccines,
              title: 'Vacuna anual',
              date: '1 de junio de 2025',),
          const _EventoCard(
              icon: Icons.cake,
              title: 'Cumpleaños',
              date: '10 de abril de 2026',),
          const _EventoCard(
              icon: Icons.medication,
              title: 'Rutina de medicina',
              date: 'Cada 8 horas',),
          const _EventoCard(
              icon: Icons.shower,
              title: 'Día de baño',
              date: 'Todos los sábados',),
          const _EventoCard(
              icon: Icons.cleaning_services,
              title: 'Limpieza dental',
              date: 'Mensual',),
          const _EventoCard(
              icon: Icons.directions_walk,
              title: 'Paseo especial',
              date: 'Domingo 9 AM',),
        ],
      ),
    );

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
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14746F),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12),),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1BB0A2),
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

class _FiltroChip extends StatelessWidget {

  const _FiltroChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label),
          labelStyle: const TextStyle(
              color: Color(0xFF14746F), fontWeight: FontWeight.bold,),
          backgroundColor: selected
              ? const Color(0xFF1BB0A2)
              : const Color(0xFF1BB0A2).withOpacity(0.2),
          side: BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
}
