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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Historial Médico',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _ProximoEventoCard(titulo: proximoEvento, fecha: fechaProximoEvento),
        const SizedBox(height: 16),
        const _BuscadorHistorial(),
        const SizedBox(height: 16),
        ...historial.entries.map((entry) => _ExpandableCard(
              title: entry.key,
              items: entry.value,
            ),),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _ProximoEventoCard extends StatelessWidget {
  const _ProximoEventoCard({
    required this.titulo,
    required this.fecha,
  });

  final String titulo;
  final String fecha;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
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
}

class _BuscadorHistorial extends StatelessWidget {
  const _BuscadorHistorial();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar en historial...',
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
        hintStyle: TextStyle(color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
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
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
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
                  Icon(Icons.folder, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    widget.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Column(
                  children: widget.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.chevron_right,
                              color: theme.colorScheme.primary,),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item['descripcion'] ?? '',
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['fecha'] ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withOpacity(0.6),),
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
}

