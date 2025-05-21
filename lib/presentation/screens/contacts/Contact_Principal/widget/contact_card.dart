import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.name,
    this.onTap,
    this.estado = 'Disponible',
  });

  final String name;
  final VoidCallback? onTap;
  final String estado;

  Color _estadoColor(BuildContext context) {
    switch (estado) {
      case 'Vacaciones':
        return Colors.amber;
      case 'No disponible':
        return Colors.grey;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  IconData _estadoIcon() {
    switch (estado) {
      case 'Vacaciones':
        return Icons.beach_access;
      case 'No disponible':
        return Icons.do_not_disturb_on;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color estadoColor = _estadoColor(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: theme.iconTheme.color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Veterinario',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.info_outline, color: theme.colorScheme.onPrimary),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(_estadoIcon(), size: 18, color: estadoColor),
                        const SizedBox(width: 8),
                        Text(
                          estado,
                          style: TextStyle(
                            color: estadoColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (estado == 'Disponible')
                      Text(
                        '08:00 - 20:00',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
