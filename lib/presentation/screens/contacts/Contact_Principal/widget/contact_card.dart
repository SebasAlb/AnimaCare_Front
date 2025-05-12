import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget { // "Disponible", "Vacaciones", "No disponible"

  const ContactCard({
    super.key,
    required this.name,
    this.onTap,
    this.estado = 'Disponible',
  });
  final String name;
  final VoidCallback? onTap;
  final String estado;

  Color _estadoColor(String estado) {
    switch (estado) {
      case 'Vacaciones':
        return const Color(0xFFFFE066); // Amarillo suave
      case 'No disponible':
        return Colors.grey;
      default:
        return const Color(0xFF1BB0A2); // Verde claro / acento
    }
  }

  IconData _estadoIcon(String estado) {
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
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF14746F), // Fondo de tarjeta: Verde marino
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.person, color: Colors.grey, size: 30),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Veterinario',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Nombre',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.info_outline, color: Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: _estadoColor(estado).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(_estadoIcon(estado),
                            size: 18, color: _estadoColor(estado),),
                        const SizedBox(width: 8),
                        Text(
                          estado,
                          style: TextStyle(
                            color: _estadoColor(estado),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (estado == 'Disponible')
                      const Text(
                        '08:00 - 20:00',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
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
