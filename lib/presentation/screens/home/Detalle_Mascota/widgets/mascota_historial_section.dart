import 'package:flutter/material.dart';

class MascotaHistorialSection extends StatelessWidget {

  const MascotaHistorialSection({
    super.key,
    required this.historial,
    required this.proximoEvento,
    required this.fechaProximoEvento,
  });
  final Map<String, List<Map<String, String>>> historial;
  final String proximoEvento;
  final String fechaProximoEvento;

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Historial Médico',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF14746F), // Verde marino
          ),
        ),
        const SizedBox(height: 16),
        _ProximoEventoCard(
          titulo: proximoEvento,
          fecha: fechaProximoEvento,
        ),
        const SizedBox(height: 16),
        const _BuscadorHistorial(),
        const SizedBox(height: 16),
        ...historial.entries.map((MapEntry<String, List<Map<String, String>>> entry) => _ExpandableCard(
            title: entry.key,
            items: entry.value,
          ),),
        const SizedBox(height: 40),
      ],
    );
}

class _ProximoEventoCard extends StatelessWidget {

  const _ProximoEventoCard({
    required this.titulo,
    required this.fecha,
  });
  final String titulo;
  final String fecha;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1BB0A2), // Verde claro
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.event_available, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Próximo evento: $titulo\nFecha: $fecha',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
}

class _BuscadorHistorial extends StatelessWidget {
  const _BuscadorHistorial();

  @override
  Widget build(BuildContext context) => TextField(
      decoration: InputDecoration(
        hintText: 'Buscar en historial...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF14746F)),
        filled: true,
        fillColor: const Color(0xFFD5F3F1),
        hintStyle: const TextStyle(color: Color(0xFF14746F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
}

class _ExpandableCard extends StatefulWidget {

  const _ExpandableCard({
    required this.title,
    required this.items,
  });
  final String title;
  final List<Map<String, String>> items;

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpand() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: _toggleExpand,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.folder, color: Color(0xFF14746F)),
                  const SizedBox(width: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF14746F),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF14746F),
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Column(
                  children: widget.items.map((Map<String, String> item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.chevron_right,
                              color: Color(0xFF1BB0A2),),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item['descripcion'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['fecha'] ?? '',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
